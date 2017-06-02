/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public struct Cookie {
    let name: String
    let value: String

    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

extension Cookie: Equatable {
    public static func ==(lhs: Cookie, rhs: Cookie) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value
    }
}

extension Array where Element == Cookie {
    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        var cookies = [Cookie]()
        var startIndex = bytes.startIndex
        var endIndex = startIndex

        while endIndex < bytes.endIndex {
            endIndex = bytes.index(
                of: Character.semicolon,
                offset: startIndex)
                ?? bytes.endIndex

            let cookie = try Cookie(
                from: bytes[startIndex..<endIndex].trimmingLeftSpace())

            cookies.append(cookie)
            startIndex = endIndex + 1
        }
        self = cookies
    }

    func encode(to buffer: inout [UInt8]) {
        for i in 0..<count {
            self[i].encode(to: &buffer)
            if i + 1 < count {
                buffer.append(Character.semicolon)
                buffer.append(Character.whitespace)
            }
        }
    }
}

extension Cookie {
    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        guard let equal = bytes.index(of: Character.equal) else {
            throw HTTPError.invalidCookie
        }
        guard
            let name = String(
                validating: bytes[..<equal].trimmingRightSpace(), as: .token),
            let value = String(
                validating: bytes[(equal+1)...].trimmingLeftSpace(), as: .token)
            else {
                throw HTTPError.invalidCookie
        }
        self.name = name
        self.value = value
    }

    func encode(to buffer: inout [UInt8]) {
        buffer.append(contentsOf: name.utf8)
        buffer.append(Character.equal)
        buffer.append(contentsOf: value.utf8)
    }
}