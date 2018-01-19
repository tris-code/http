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

extension Request.Authorization {
    private struct Bytes {
        static let basic = ASCII("Basic")
        static let bearer = ASCII("Bearer")
        static let token = ASCII("Token")
    }

    init<T: UnsafeStreamReader>(from stream: T) throws {
        var buffer = try stream.read(until: .whitespace)
        let schemeHashValue = buffer.lowercasedHashValue

        func readCredentials() throws -> String {
            guard try stream.consume(.whitespace) else {
                throw ParseError.invalidAuthorizationHeader
            }
            // FIXME: validate with value-specific rule
            buffer = try stream.read(allowedBytes: .text)
            return String(decoding: buffer, as: UTF8.self)
        }

        switch schemeHashValue {
        case Bytes.basic.lowercasedHashValue:
            self = .basic(credentials: try readCredentials())
        case Bytes.bearer.lowercasedHashValue:
            self = .bearer(credentials: try readCredentials())
        case Bytes.token.lowercasedHashValue:
            self = .token(credentials: try readCredentials())
        default:
            let scheme = String(decoding: buffer, as: UTF8.self)
            self = .custom(scheme: scheme, credentials:  try readCredentials())
        }
    }

    func encode<T: UnsafeStreamWriter>(to stream: T) throws {
        switch self {
        case .basic(let credentials):
            try stream.write(Bytes.basic)
            try stream.write(.whitespace)
            try stream.write(credentials)
        case .bearer(let credentials):
            try stream.write(Bytes.bearer)
            try stream.write(.whitespace)
            try stream.write(credentials)
        case .token(let credentials):
            try stream.write(Bytes.token)
            try stream.write(.whitespace)
            try stream.write(credentials)
        case .custom(let schema, let credentials):
            try stream.write(schema)
            try stream.write(.whitespace)
            try stream.write(credentials)
        }
    }
}