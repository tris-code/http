/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

extension Request {
    public enum Method {
        case get
        case head
        case post
        case put
        case delete
        case options
    }
}

extension Request.Method {
    var bytes: [UInt8] {
        switch self {
        case .get: return RequestMethodBytes.get
        case .head: return RequestMethodBytes.head
        case .post: return RequestMethodBytes.post
        case .put: return RequestMethodBytes.put
        case .delete: return RequestMethodBytes.delete
        case .options: return RequestMethodBytes.options
        }
    }
}

extension Request.Method {
    init(from buffer: UnsafeRawBufferPointer) throws {
        for (type, bytes) in RequestMethodBytes.values {
            if buffer.elementsEqual(bytes) {
                self = type
                return
            }
        }
        throw HTTPError.invalidMethod
    }
}

fileprivate struct RequestMethodBytes {
    static let get = ASCII("GET")
    static let head = ASCII("HEAD")
    static let post = ASCII("POST")
    static let put = ASCII("PUT")
    static let delete = ASCII("DELETE")
    static let options = ASCII("OPTIONS")

    static let values: [(Request.Method, ASCII)] = [
        (.get, get),
        (.head, head),
        (.post, post),
        (.put, put),
        (.delete, delete),
        (.options, options),
    ]
}
