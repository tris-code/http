/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import Buffer
import MemoryStream

extension Request {
    // TODO: move to Tests?
    public init(from bytes: [UInt8]) throws {
        let stream = MemoryStream(capacity: bytes.count)
        _ = try stream.write(bytes)
        try stream.seek(to: 0, from: .begin)
        let inputBuffer = InputBuffer(source: stream)
        try self.init(from: inputBuffer)
    }

    public init<T: InputBufferProtocol>(from buffer: T) throws {
        guard let method = try buffer.read(until: Character.whitespace) else {
            throw HTTPError.unexpectedEnd
        }
        self.method = try Request.Method(from: method)
        try buffer.consume(count: 1)

        guard let url = try buffer.read(until: Character.whitespace) else {
            throw HTTPError.unexpectedEnd
        }
        self.url = try URL(from: url)
        try buffer.consume(count: 1)

        guard let version = try buffer.read(until: Character.cr) else {
            throw HTTPError.unexpectedEnd
        }
        self.version = try Version(from: version)

        @inline(__always)
        func readLineEnd() throws {
            guard let lineEnd = try? buffer.read(count: 2) else {
                throw HTTPError.unexpectedEnd
            }
            guard lineEnd.elementsEqual(Constants.lineEnd) else {
                throw HTTPError.invalidRequest
            }
        }

        try readLineEnd()

        while true {
            guard let headerStart = try buffer.read(while: {
                $0 != Character.colon && $0 != Character.lf
            }) else {
                throw HTTPError.unexpectedEnd
            }
            // "\r\n" found
            guard headerStart.first != Character.cr else {
                try buffer.consume(count: 1)
                break
            }
            let headerName = try HeaderName(from: headerStart)

            try buffer.consume(count: 1)

            guard let value = try buffer.read(until: Character.cr) else {
                throw HTTPError.unexpectedEnd
            }
            let headerValue = value.trimmingLeftSpace().trimmingRightSpace()

            try readLineEnd()

            switch headerName {
            case .host:
                self.host = String(validating: headerValue, as: .text)
            case .userAgent:
                self.userAgent = String(validating: headerValue, as: .text)
            case .accept:
                self.accept = try [Accept](from: headerValue)
            case .acceptLanguage:
                self.acceptLanguage =
                    try [AcceptLanguage](from: headerValue)
            case .acceptEncoding:
                self.acceptEncoding =
                    try [ContentEncoding](from: headerValue)
            case .acceptCharset:
                self.acceptCharset = try [AcceptCharset](from: headerValue)
            case .authorization:
                self.authorization = try Authorization(from: headerValue)
            case .keepAlive:
                self.keepAlive = Int(from: headerValue)
            case .connection:
                self.connection = try Connection(from: headerValue)
            case .contentLength:
                self.contentLength = Int(from: headerValue)
            case .contentType:
                self.contentType = try ContentType(from: headerValue)
            case .transferEncoding:
                self.transferEncoding =
                    try [TransferEncoding](from: headerValue)
            case .cookie:
                self.cookies.append(
                    contentsOf: try [Cookie](from: headerValue))
            default:
                headers[headerName] =
                    String(validating: headerValue, as: .text)
            }
        }

        // Body

        // 1. content-lenght
        if let length = self.contentLength {
            guard length > 0 else {
                self.rawBody = nil
                return
            }
            self.rawBody = [UInt8](try buffer.read(count: length))
            return
        }

        // 2. chunked
        guard let transferEncoding = self.transferEncoding,
            transferEncoding.contains(.chunked) else {
                return
        }

        var body = [UInt8]()

        while true {
            guard let sizeBytes = try buffer.read(until: Character.cr) else {
                throw HTTPError.unexpectedEnd
            }
            try readLineEnd()

            // TODO: optimize using hex table
            guard let size = Int(from: sizeBytes, radix: 16) else {
                throw HTTPError.invalidRequest
            }
            guard size > 0 else {
                break
            }

            body.append(contentsOf: try buffer.read(count: size))
            try readLineEnd()
        }

        self.rawBody = body

        if buffer.count >= 2,
            buffer.peek(count: 2)!.elementsEqual(Constants.lineEnd) {
                try buffer.consume(count: 2)
        }
    }
}
