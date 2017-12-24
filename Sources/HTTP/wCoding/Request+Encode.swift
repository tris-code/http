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
    @_specialize(exported: true, where T == BufferedOutputStream<NetworkStream>)
    public func encode<T: UnsafeStreamWriter>(to stream: T) throws {
        // Start Line
        try method.encode(to: stream)
        try stream.write(.whitespace)
        try url.path.encode(to: stream, allowedCharacters: .urlPathAllowed)
        if method == .get, let query = url.query, query.values.count > 0 {
            try stream.write(.questionMark)
            try query.encode(to: stream)
        }
        try stream.write(.whitespace)
        try version.encode(to: stream)
        try stream.write(Constants.lineEnd)

        // Headers
        @inline(__always)
        func writeHeader(
            _ name: HeaderName,
            encoder: (T) throws -> Void
        ) throws {
            try stream.write(name.bytes)
            try stream.write(.colon)
            try stream.write(.whitespace)
            try encoder(stream)
            try stream.write(Constants.lineEnd)
        }

        @inline(__always)
        func writeHeader(_ name: HeaderName, value: String) throws {
            try writeHeader(name) { stream in
                try stream.write(value)
            }
        }

        if let host = self.host {
            try writeHeader(.host, encoder: host.encode)
        }

        if let contentType = self.contentType {
            try writeHeader(.contentType, encoder: contentType.encode)
        }

        if let contentLength = self.contentLength {
            try writeHeader(.contentLength, value: String(contentLength))
        }

        if let userAgent = self.userAgent {
            try writeHeader(.userAgent, value: userAgent)
        }

        if let accept = self.accept {
            try writeHeader(.accept, encoder: accept.encode)
        }

        if let acceptLanguage = self.acceptLanguage {
            try writeHeader(.acceptLanguage, encoder: acceptLanguage.encode)
        }

        if let acceptEncoding = self.acceptEncoding {
            try writeHeader(.acceptEncoding, encoder: acceptEncoding.encode)
        }

        if let acceptCharset = self.acceptCharset {
            try writeHeader(.acceptCharset, encoder: acceptCharset.encode)
        }

        if let authorization = self.authorization {
            try writeHeader(.authorization, encoder: authorization.encode)
        }

        if let keepAlive = self.keepAlive {
            try writeHeader(.keepAlive, value: String(keepAlive))
        }

        if let connection = self.connection {
            try writeHeader(.connection, encoder: connection.encode)
        }

        if let transferEncoding = self.transferEncoding {
            try writeHeader(.transferEncoding, encoder: transferEncoding.encode)
        }

        for (key, value) in headers {
            try writeHeader(key, value: value)
        }

        // Cookies
        for cookie in cookies {
            try writeHeader(.cookie, encoder: cookie.encode)
        }

        // Separator
        try stream.write(Constants.lineEnd)

        // Body
        switch body {
        case .bytes(let bytes): try stream.write(bytes)
        // TODO:
        // case .output(let writer): try writer(stream)
        default: break
        }
    }
}
