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

final class AllowedBytes {
    @_versioned
    let buffer: UnsafeBufferPointer<Bool>

    init(byteSet set: Set<UInt8>) {
        let buffer = UnsafeMutableBufferPointer<Bool>.allocate(capacity: 256)
        buffer.initialize(repeating: false)
        for byte in set {
            buffer[Int(byte)] = true
        }
        self.buffer = UnsafeBufferPointer(buffer)
    }

    init(usASCII table: ASCIITable) {
        let buffer = UnsafeMutableBufferPointer<Bool>.allocate(capacity: 256)
        buffer.initialize(repeating: false)

        var copy = table
        let pointer = UnsafeMutableRawPointer(mutating: &copy)
            .assumingMemoryBound(to: Bool.self)
        let asciiBuffer = UnsafeBufferPointer(start: pointer, count: 128)
        _ = buffer.initialize(from: asciiBuffer)

        self.buffer = UnsafeBufferPointer(buffer)
    }

    deinit {
        buffer.deallocate()
    }
}

extension BufferedInputStream {
    @inline(__always)
    func read(allowedBytes: AllowedBytes) throws -> UnsafeRawBufferPointer {
        let buffer = allowedBytes.buffer
        return try read(while: { buffer[Int($0)] })
    }
}

typealias ASCIITable = (
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool)
