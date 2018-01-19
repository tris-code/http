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
import Async
import Network
import Platform
import Stream

public class Server {
    public var bufferSize: Int

    let networkServer: Network.Server

    @_versioned
    var router = Router()

    public init(host: String, port: Int, bufferSize: Int = 4096) throws {
        self.bufferSize = bufferSize
        self.networkServer = try Network.Server(host: host, port: port)
        self.networkServer.onClient = onClient
    }

    public init(host: String, reusePort: Int, bufferSize: Int = 4096) throws {
        self.bufferSize = bufferSize
        self.networkServer = try Network.Server(host: host, reusePort: reusePort)
        self.networkServer.onClient = onClient
    }

    public var address: String {
        return "http://\(networkServer.address)"
    }

    public func start() throws {
        Log.info("server at \(address) started")
        try networkServer.start()
    }

    func onClient(socket: Socket) {
        let stream = NetworkStream(socket: socket)
        process(stream: stream)
    }

    func process<T: Stream>(stream: T) {
        do {
            let inputStream = BufferedInputStream(
                baseStream: stream, capacity: bufferSize)
            let outputStream = BufferedOutputStream(
                baseStream: stream, capacity: bufferSize)

            while true {
                let request = try Request(from: inputStream)
                if request.expect == .continue {
                    let `continue` = Response(status: .continue)
                    try `continue`.encode(to: outputStream)
                    try outputStream.flush()
                }
                let response = makeResponse(for: request)
                try response.encode(to: outputStream)
                try outputStream.flush()
                if request.connection == .close {
                    break
                }
            }
        } catch let error as ParseError where error == .unexpectedEnd {
            /* connection closed */
        } catch let error as SocketError where error.number == ECONNRESET {
            /* connection closed */
        } catch let error as NetworkStream.Error where error == .closed {
            /* connection closed */
        } catch {
            /* log other errors */
            log(event: .error, message: String(describing: error))
        }
    }

    func makeResponse(for request: Request) -> Response {
        do {
            return try handleRequest(request)
        } catch let error as RouterError where error == .notFound {
            log(event: .warning, message: "not found: \(request)")
            return Response(status: .notFound)
        } catch {
            log(event: .error, message: String(describing: error))
            return Response(status: .internalServerError)
        }
    }
}
