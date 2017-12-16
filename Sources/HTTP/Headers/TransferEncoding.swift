/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public enum TransferEncoding {
    case chunked
    case compress
    case deflate
    case gzip
    case identity
}

extension TransferEncoding: Equatable {
    public static func ==(
        lhs: TransferEncoding,
        rhs: TransferEncoding
    ) -> Bool {
        switch (lhs, rhs) {
        case (.chunked, .chunked): return true
        case (.compress, .compress): return true
        case (.deflate, .deflate): return true
        case (.gzip, .gzip): return true
        case (.identity, .identity): return true
        default: return false
        }
    }
}

extension Array where Element == TransferEncoding {
    init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        var startIndex = bytes.startIndex
        var endIndex = startIndex
        var values = [TransferEncoding]()
        while endIndex < bytes.endIndex {
            endIndex =
                bytes.index(of: .comma, offset: startIndex) ??
                bytes.endIndex
            let value = try TransferEncoding(from: bytes[startIndex..<endIndex])
            values.append(value)
            startIndex = endIndex.advanced(by: 1)
            if startIndex < bytes.endIndex &&
                bytes[startIndex] == .whitespace {
                    startIndex += 1
            }
        }
        self = values
    }

    func encode(to buffer: inout [UInt8]) {
        for i in startIndex..<endIndex {
            if i != startIndex {
                buffer.append(.comma)
            }
            self[i].encode(to: &buffer)
        }
    }
}

extension TransferEncoding {
    private struct Bytes {
        static let chunked = ASCII("chunked")
        static let compress = ASCII("compress")
        static let deflate = ASCII("deflate")
        static let gzip = ASCII("gzip")
        static let identity = ASCII("identity")
    }

    init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        switch bytes.lowercasedHashValue {
        case Bytes.chunked.lowercasedHashValue: self = .chunked
        case Bytes.compress.lowercasedHashValue: self = .compress
        case Bytes.deflate.lowercasedHashValue: self = .deflate
        case Bytes.gzip.lowercasedHashValue: self = .gzip
        case Bytes.identity.lowercasedHashValue: self = .identity
        default: throw HTTPError.invalidHeaderValue
        }
    }

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .chunked: buffer.append(contentsOf: Bytes.chunked)
        case .compress: buffer.append(contentsOf: Bytes.compress)
        case .deflate: buffer.append(contentsOf: Bytes.deflate)
        case .gzip: buffer.append(contentsOf: Bytes.gzip)
        case .identity: buffer.append(contentsOf: Bytes.identity)
        }
    }
}
