/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import class Foundation.JSONSerialization

public struct Request {
    public var method: Method
    public var url: URL
    public var version: Version

    public var host: String? = nil
    public var userAgent: String? = nil
    public var accept: [Accept]? = nil
    public var acceptLanguage: [AcceptLanguage]? = nil
    public var acceptEncoding: [ContentEncoding]? = nil
    public var acceptCharset: [AcceptCharset]? = nil
    public var authorization: Authorization? = nil
    public var keepAlive: Int? = nil
    public var connection: Connection? = nil
    public var contentType: ContentType? = nil
    public var contentLength: Int? = nil
    public var transferEncoding: [TransferEncoding]? = nil

    public var headers: [HeaderName : String] = [:]

    public var cookies: [Cookie] = []

    public var rawBody: [UInt8]? = nil {
        didSet {
            contentLength = rawBody?.count
        }
    }
}

extension Request {
    public var shouldKeepAlive: Bool {
        if self.connection == .close {
            return false
        }
        return true
    }

    public var body: String? {
        guard let rawBody = rawBody else {
            return nil
        }
        return String(bytes: rawBody, encoding: .utf8)
    }

    public init(method: Method = .get, url: URL = URL(path: "/")) {
        self.method = method
        self.url = url
        self.version = .oneOne
    }
}

extension Request {
    public init(method: Method, url: URL, json object: Any) throws {
        let bytes = [UInt8](try JSONSerialization.data(withJSONObject: object))
        self.init(method: method, url: url)
        self.contentType = ContentType(mediaType: .application(.json))
        self.rawBody = bytes
        self.contentLength = bytes.count
    }

    public init(
        method: Method,
        url: URL,
        urlEncoded values: [String : String]
    ) throws {
        let bytes = [UInt8](URL.encode(values: values).utf8)

        self.init(method: method, url: url)
        self.contentType = ContentType(mediaType: .application(.urlEncoded))
        self.rawBody = bytes
        self.contentLength = bytes.count
    }
}

extension Request {
    public var bytes: [UInt8] {
        var bytes = [UInt8]()
        encode(to: &bytes)
        return bytes
    }

    func encode(to buffer: inout [UInt8]) {
        // Start Line
        method.encode(to: &buffer)
        buffer.append(Character.whitespace)
        url.encode(to: &buffer)
        buffer.append(Character.whitespace)
        version.encode(to: &buffer)
        buffer.append(contentsOf: Constants.lineEnd)

        // Headers
        @inline(__always)
        func writeHeader(_ name: HeaderName, encoder: (inout [UInt8]) -> Void) {
            buffer.append(contentsOf: name.bytes)
            buffer.append(Character.colon)
            buffer.append(Character.whitespace)
            encoder(&buffer)
            buffer.append(contentsOf: Constants.lineEnd)
        }

        @inline(__always)
        func writeHeader(_ name: HeaderName, value: String) {
            buffer.append(contentsOf: name.bytes)
            buffer.append(Character.colon)
            buffer.append(Character.whitespace)
            buffer.append(contentsOf: value.utf8)
            buffer.append(contentsOf: Constants.lineEnd)
        }

        if let host = self.host {
            writeHeader(.host, value: host)
        }

        if let contentType = self.contentType {
            writeHeader(.contentType, encoder: contentType.encode)
        }

        if let contentLength = self.contentLength {
            writeHeader(.contentLength, value: String(contentLength))
        }

        if let userAgent = self.userAgent {
            writeHeader(.userAgent, value: userAgent)
        }

        if let accept = self.accept {
            writeHeader(.accept, encoder: accept.encode)
        }

        if let acceptLanguage = self.acceptLanguage {
            writeHeader(.acceptLanguage, encoder: acceptLanguage.encode)
        }

        if let acceptEncoding = self.acceptEncoding {
            writeHeader(.acceptEncoding, encoder: acceptEncoding.encode)
        }

        if let acceptCharset = self.acceptCharset {
            writeHeader(.acceptCharset, encoder: acceptCharset.encode)
        }

        if let authorization = self.authorization {
            writeHeader(.authorization, encoder: authorization.encode)
        }

        if let keepAlive = self.keepAlive {
            writeHeader(.keepAlive, value: String(keepAlive))
        }

        if let connection = self.connection {
            writeHeader(.connection, encoder: connection.encode)
        }

        if let transferEncoding = self.transferEncoding {
            writeHeader(.transferEncoding, encoder: transferEncoding.encode)
        }

        for (key, value) in headers {
            writeHeader(key, value: value)
        }

        // Cookies
        for cookie in cookies {
            writeHeader(.cookie, encoder: cookie.encode)
        }

        // Separator
        buffer.append(contentsOf: Constants.lineEnd)

        // Body
        if let rawBody = rawBody {
            buffer.append(contentsOf: rawBody)
        }
    }
}

extension Request {
    public init(from bytes: [UInt8]) throws {
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        try self.init(from: buffer[...])
    }

    public init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        var startIndex = 0
        guard let whitespace = bytes.index(of: Character.whitespace) else {
            throw HTTPError.unexpectedEnd
        }
        var endIndex = whitespace
        self.method = try Request.Method(from: bytes[startIndex..<endIndex])

        startIndex = endIndex.advanced(by: 1)
        guard let urlEndIndex =
            bytes.index(of: Character.whitespace, offset: startIndex) else {
                throw HTTPError.unexpectedEnd
        }
        endIndex = urlEndIndex
        self.url = URL(from: bytes[startIndex..<endIndex])

        startIndex = endIndex.advanced(by: 1)
        guard let lineEnd =
            bytes.index(of: Character.cr, offset: startIndex) else {
                throw HTTPError.unexpectedEnd
        }
        endIndex = lineEnd
        self.version = try Version(from: bytes[startIndex..<endIndex])

        startIndex = endIndex.advanced(by: 2)
        guard startIndex < bytes.endIndex else {
            throw HTTPError.unexpectedEnd
        }
        guard bytes[endIndex..<startIndex]
            .elementsEqual(Constants.lineEnd) else {
                throw HTTPError.invalidRequest
        }

        while startIndex + Constants.minimumHeaderLength < bytes.endIndex
            && !bytes[startIndex...].starts(with: Constants.lineEnd) {
                guard let headerNameEndIndex = bytes.index(
                    of: Character.colon,
                    offset: startIndex) else {
                        throw HTTPError.unexpectedEnd
                }
                endIndex = headerNameEndIndex
                let headerNameBuffer = bytes[startIndex..<endIndex]
                let headerName = try HeaderName(from: headerNameBuffer)

                startIndex = endIndex.advanced(by: 1)
                guard let headerValueEndIndex = bytes.index(
                    of: Character.cr,
                    offset: startIndex) else {
                        throw HTTPError.unexpectedEnd
                }
                endIndex = headerValueEndIndex

                let headerValue = bytes[startIndex..<endIndex]
                    .trimmingLeftSpace()
                    .trimmingRightSpace()

                switch headerName {
                case .host:
                    self.host = String(buffer: headerValue)
                case .userAgent:
                    self.userAgent = String(buffer: headerValue)
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
                    self.keepAlive = Int(String(buffer: headerValue))
                case .connection:
                    self.connection = try Connection(from: headerValue)
                case .contentLength:
                    self.contentLength = Int(String(buffer: headerValue))
                case .contentType:
                    self.contentType = try ContentType(from: headerValue)
                case .transferEncoding:
                    self.transferEncoding =
                        try [TransferEncoding](from: headerValue)
                case .cookie:
                    self.cookies.append(
                        contentsOf: try [Cookie](from: headerValue))
                default:
                    headers[headerName] = String(buffer: headerValue)
                }

                startIndex = endIndex.advanced(by: 2)
        }

        guard startIndex + 2 <= bytes.endIndex,
            bytes[startIndex] == Character.cr,
            bytes[startIndex + 1] == Character.lf else {
                throw HTTPError.unexpectedEnd
        }
        bytes.formIndex(&startIndex, offsetBy: 2)

        // Body

        // 1. content-lenght
        if let length = self.contentLength {
            guard length > 0 else {
                self.rawBody = nil
                return
            }
            endIndex = startIndex.advanced(by: length)
            guard endIndex <= bytes.endIndex else {
                throw HTTPError.unexpectedEnd
            }
            self.rawBody = [UInt8](bytes[startIndex..<endIndex])
            return
        }

        // 2. chunked
        guard let transferEncoding = self.transferEncoding,
            transferEncoding.contains(.chunked) else {
                return
        }

        self.rawBody = []

        while startIndex + Constants.minimumChunkLength <= bytes.endIndex {
            guard let lineEndIndex =
                bytes.index(of: Character.cr, offset: startIndex) else {
                    throw HTTPError.unexpectedEnd
            }
            endIndex = lineEndIndex
            guard bytes[endIndex.advanced(by: 1)] == Character.lf else {
                throw HTTPError.invalidRequest
            }

            // TODO: optimize using hex table
            let hexSize = String(buffer: bytes[startIndex..<endIndex])
            guard let size = Int(hexSize, radix: 16) else {
                throw HTTPError.invalidRequest
            }
            guard size > 0 else {
                startIndex = endIndex.advanced(by: 2)
                break
            }

            startIndex = endIndex.advanced(by: 2)
            endIndex = startIndex.advanced(by: size)
            guard endIndex < bytes.endIndex else {
                throw HTTPError.unexpectedEnd
            }

            rawBody!.append(contentsOf: [UInt8](bytes[startIndex..<endIndex]))
            startIndex = endIndex.advanced(by: 2)
        }


        guard startIndex == bytes.endIndex || (
            startIndex == bytes.endIndex.advanced(by: -2) &&
                bytes[startIndex...].elementsEqual(Constants.lineEnd)) else {
                    throw HTTPError.unexpectedEnd
        }
    }
}
