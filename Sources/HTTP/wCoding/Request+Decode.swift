/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import Stream
import Network

extension Request {
    @_specialize(exported: true, where T == BufferedInputStream<NetworkStream>)
    public convenience init<T: UnsafeStreamReader>(from stream: T) throws {
        self.init()
        do {
            self.method = try Request.Method(from: stream)
            guard try stream.consume(.whitespace) else {
                throw ParseError.invalidStartLine
            }

            self.url = try URL(from: stream)
            guard try stream.consume(.whitespace) else {
                throw ParseError.invalidStartLine
            }

            self.version = try Version(from: stream)

            @inline(__always)
            func readLineEnd() throws {
                guard try stream.consume(.cr),
                    try stream.consume(.lf) else {
                        throw ParseError.invalidRequest
                }
            }

            try readLineEnd()

            while true {
                guard let nextLine = try stream.peek(count: 2) else {
                    throw ParseError.unexpectedEnd
                }
                if nextLine.elementsEqual(Constants.lineEnd) {
                    try stream.consume(count: 2)
                    break
                }

                let name = try HeaderName(from: stream)

                guard try stream.consume(.colon) else {
                    throw ParseError.invalidHeaderName
                }
                try stream.consume(while: { $0 == .whitespace })

                switch name {
                case .host:
                    guard self.url.host == nil else {
                        try stream.consume(until: .cr)
                        continue
                    }
                    self.host = try URL.Host(from: stream)
                case .userAgent:
                    // FIXME: validate
                    let bytes = try stream.read(until: .cr)
                    let trimmed = bytes.trimmingRightSpace()
                    self.userAgent = String(decoding: trimmed, as: UTF8.self)
                case .accept:
                    self.accept = try [Accept](from: stream)
                case .acceptLanguage:
                    self.acceptLanguage = try [AcceptLanguage](from: stream)
                case .acceptEncoding:
                    self.acceptEncoding = try [ContentEncoding](from: stream)
                case .acceptCharset:
                    self.acceptCharset = try [AcceptCharset](from: stream)
                case .authorization:
                    self.authorization = try Authorization(from: stream)
                case .keepAlive:
                    self.keepAlive = try Int(from: stream)
                case .connection:
                    self.connection = try Connection(from: stream)
                case .contentLength:
                    self.contentLength = try Int(from: stream)
                case .contentType:
                    self.contentType = try ContentType(from: stream)
                case .transferEncoding:
                    self.transferEncoding = try [TransferEncoding](from: stream)
                case .cookie:
                    self.cookies.append(contentsOf: try [Cookie](from: stream))
                case .expect:
                    self.expect = try Expect(from: stream)
                default:
                    // FIXME: validate
                    let bytes = try stream.read(until: .cr)
                    let trimmed = bytes.trimmingRightSpace()
                    headers[name] = String(decoding: trimmed, as: UTF8.self)
                }

                try readLineEnd()
            }

            // Body

            self.body = .input(stream)

        } catch let error as StreamError where error == .insufficientData {
            throw ParseError.unexpectedEnd
        }
    }
}
