/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import Log
import Stream

protocol RequestHandlerProtocol {
    func handleRequest(_ request: Request) -> Response?
}

protocol StreamingServer: RequestHandlerProtocol {
    var bufferSize: Int { get }
    func process<T: Stream>(stream: T) throws
}

extension StreamingServer {
    func process<T: Stream>(stream: T) throws {
        try process(
            inputStream: BufferedInputStream(
                baseStream: stream,
                capacity: bufferSize),
            outputStream: BufferedOutputStream(
                baseStream: stream,
                capacity: bufferSize))
    }

    func process<I: InputStream, O: OutputStream>(
        inputStream: BufferedInputStream<I>,
        outputStream: BufferedOutputStream<O>
    ) throws {
        while true {
            let request = try Request(from: inputStream)
            if request.expect == .continue {
                let `continue` = Response(status: .continue)
                try `continue`.encode(to: outputStream)
                try outputStream.flush()
            }
            if let response = handleRequest(request) {
                try response.encode(to: outputStream)
                try outputStream.flush()
            }
            if request.connection == .close {
                break
            }
        }
    }
}

extension RouterProtocol {
    func handleRequest(_ request: Request) -> Response? {
        do {
            return try process(request: request)
        } catch {
            return handleError(error, for: request)
        }
    }

    func handleError(_ error: Swift.Error, for request: Request) -> Response? {
        switch error {
        case let error as Error where error == .notFound:
            log(event: .warning, message: "not found: \(request.url.path)")
            return Response(status: .notFound)
        default:
            log(event: .error, message: String(describing: error))
            return Response(status: .internalServerError)
        }
    }
}

extension RouterProtocol {
    func process(request: Request) throws -> Response {
        let path = request.url.path
        let methods = Router.MethodSet(request.method)
        guard let handler = findHandler(path: path, methods: methods) else {
            throw Error.notFound
        }
        return try handler(request)
    }
}

extension Router.MethodSet {
    init(_ method: Request.Method) {
        switch method {
        case .get: self = .get
        case .head: self = .head
        case .post: self = .post
        case .put: self = .put
        case .delete: self = .delete
        case .options: self = .options
        }
    }
}