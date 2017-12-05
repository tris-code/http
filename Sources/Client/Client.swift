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
import Buffer

// FIXME:
// linker issue on macOS
import struct Foundation.Date

@_exported import HTTP

public class Client {
    let host: URL.Host
    var stream: NetworkStream?
    var inputBuffer: InputBuffer<NetworkStream>?

    public var isConnected: Bool {
        return stream != nil
    }

    public var bufferSize = 4096

    public init(host: String, port: Int) throws {
        self.host = URL.Host(address: host, port: port)
    }

    public func connect() throws {
        if isConnected {
            disconnect()
        }

        let port = host.port ?? 80
        let socket = try Socket()
        try socket.connect(to: host.address, port: UInt16(port))

        self.stream = NetworkStream(socket: socket)
        self.inputBuffer = InputBuffer(capacity: bufferSize, source: stream!)
    }

    public func disconnect() {
        self.stream = nil
        self.inputBuffer = nil
    }

    public func makeRequest(_ request: Request) throws -> Response {
        if !isConnected {
            try connect()
        }

        do {
            try request.encode(to: &stream!)
            return try Response(from: inputBuffer!)
        } catch {
            disconnect()
            throw error
        }
    }
}

extension Client {
    public func get(path: String) throws -> Response {
        return try makeRequest(Request(method: .get, url: URL(path)))
    }

    public func head(path: String) throws -> Response {
        return try makeRequest(Request(method: .head, url: URL(path)))
    }

    public func post(path: String) throws -> Response {
        return try makeRequest(Request(method: .post, url: URL(path)))
    }

    public func put(path: String) throws -> Response {
        return try makeRequest(Request(method: .put, url: URL(path)))
    }

    public func delete(path: String) throws -> Response {
        return try makeRequest(Request(method: .delete, url: URL(path)))
    }

    public func options(path: String) throws -> Response {
        return try makeRequest(Request(method: .options, url: URL(path)))
    }
}

extension Client {
    public func post<T: Encodable>(
        path: String,
        json object: T
    ) throws -> Response {
        let request = try Request(method: .post, url: URL(path), json: object)
        return try makeRequest(request)
    }

    public func post<T: Encodable>(
        path: String,
        urlEncoded object: T
    ) throws -> Response {
        let request = try Request(
            method: .post, url: URL(path), urlEncoded: object)
        return try makeRequest(request)
    }
}
