/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import Test
import Stream
import Network
import Dispatch
import AsyncDispatch

@testable import HTTP

import struct Foundation.Data

extension Response {
    func encode() throws -> [UInt8] {
        let stream = OutputByteStream()
        try self.encode(to: stream)
        return stream.bytes
    }
}

extension OutputByteStream {
    var string: String {
        return String(decoding: bytes, as: UTF8.self)
    }
}

extension InputByteStream {
    convenience init(_ string: String) {
        self.init(ASCII(string))
    }
}

class ClientTests: TestCase {
    override func setUp() {
        AsyncDispatch().registerGlobal()
    }

    func testInitializer() {
        let client = HTTP.Client(host: "127.0.0.1", port: 80)
        assertEqual(client.host, URL.Host(address: "127.0.0.1", port: 80))
    }

    func testURLInitializer() {
        guard let client = HTTP.Client(url: "http://127.0.0.1") else {
            fail()
            return
        }
        assertEqual(client.host, URL.Host(address: "127.0.0.1", port: 80))
    }

    func testRequest() {
        do {
            let requestString = "GET / HTTP/1.1\r\n" +
                "Host: 127.0.0.1:8080\r\n" +
                "User-Agent: tris-foundation/http\r\n" +
                "Accept-Encoding: gzip, deflate\r\n" +
                "\r\n"

            let inputStream = InputByteStream("HTTP/1.1 200 OK\r\n\r\n")
            let input = BufferedInputStream(baseStream: inputStream)

            let outputStream = OutputByteStream()
            let output = BufferedOutputStream(baseStream: outputStream)

            let client = HTTP.Client(host: "127.0.0.1", port: 8080)
            let request = Request()

            let response = try client.makeRequest(request, input, output)
            assertEqual(outputStream.string, requestString)
            assertEqual(response.status, .ok)
        } catch {
            fail(String(describing: error))
        }
    }

    func testDeflate() {
        do {
            let requestString = "GET / HTTP/1.1\r\n" +
                "Host: 127.0.0.1:8080\r\n" +
                "User-Agent: tris-foundation/http\r\n" +
                "Accept-Encoding: gzip, deflate\r\n" +
                "\r\n"

            let deflateBase64 = "80jNycnXUQjPL8pJUQQA"
            let deflateBody = [UInt8](Data(base64Encoded: deflateBase64)!)
            let responseBytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: \(deflateBody.count)\r\n" +
                "Content-Encoding: Deflate\r\n" +
                "\r\n") + deflateBody

            let inputStream = InputByteStream(responseBytes)
            let input = BufferedInputStream(baseStream: inputStream)

            let outputStream = OutputByteStream()
            let output = BufferedOutputStream(baseStream: outputStream)

            let client = HTTP.Client(host: "127.0.0.1", port: 8080)
            let request = Request()

            let response = try client.makeRequest(request, input, output)
            assertEqual(outputStream.string, requestString)
            assertEqual(response.status, .ok)
            assertEqual(response.contentEncoding, [.deflate])
            assertEqual(response.string, "Hello, World!")
        } catch {
            fail(String(describing: error))
        }
    }

    func testGZip() {
        do {
            let requestString = "GET / HTTP/1.1\r\n" +
                "Host: 127.0.0.1:8080\r\n" +
                "User-Agent: tris-foundation/http\r\n" +
                "Accept-Encoding: gzip, deflate\r\n" +
                "\r\n"

            let gzipBase64 = "H4sIAAAAAAAAE/NIzcnJ11EIzy/KSVEEANDDSuwNAAAA"
            let gzipBody = [UInt8](Data(base64Encoded: gzipBase64)!)
            let responseBytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: \(gzipBody.count)\r\n" +
                "Content-Encoding: gzip\r\n" +
                "\r\n") + gzipBody

            let inputStream = InputByteStream(responseBytes)
            let input = BufferedInputStream(baseStream: inputStream)

            let outputStream = OutputByteStream()
            let output = BufferedOutputStream(baseStream: outputStream)

            let client = HTTP.Client(host: "127.0.0.1", port: 8080)
            let request = Request()

            let response = try client.makeRequest(request, input, output)
            assertEqual(outputStream.string, requestString)
            assertEqual(response.status, .ok)
            assertEqual(response.contentEncoding, [.gzip])
            assertEqual(response.string, "Hello, World!")
        } catch {
            fail(String(describing: error))
        }
    }


    static var allTests = [
        ("testInitializer", testInitializer),
        ("testURLInitializer", testURLInitializer),
        ("testRequest", testRequest),
        ("testDeflate", testDeflate),
        ("testGZip", testGZip)
    ]
}
