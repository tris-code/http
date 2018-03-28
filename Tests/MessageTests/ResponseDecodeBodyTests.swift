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
@testable import HTTP

import struct Foundation.Date

class ResponseDecodeBodyTests: TestCase {
    func testStringResponse() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/plain\r\n" +
                "Content-Length: 5\r\n" +
                "\r\n" +
                "Hello")
            let response = try Response(from: stream)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .text(.plain)))
            assertEqual(response.contentLength, 5)
            assertEqual(response.bytes, ASCII("Hello"))
            assertEqual(response.string, "Hello")
        }
    }

    func testHtmlResponse() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/html\r\n" +
                "Content-Length: 13\r\n" +
                "\r\n" +
                "<html></html>")
            let response = try Response(from: stream)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .text(.html))
            )
            assertEqual(response.contentLength, 13)
            assertEqual(response.bytes, ASCII("<html></html>"))
            assertEqual(response.string, "<html></html>")
        }
    }

    func testBytesResponse() {
        scope {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: application/stream\r\n" +
                "Content-Length: 3\r\n" +
                "\r\n") + [1,2,3]
            let stream = InputByteStream(bytes)
            let response = try Response(from: stream)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .application(.stream))
            )
            assertEqual(response.contentLength, 3)
            assertEqual(response.bytes, [1,2,3])
        }
    }

    func testJsonResponse() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: application/json\r\n" +
                "Content-Length: 28\r\n" +
                "\r\n" +
                "{'message': 'Hello, World!'}")
            let response = try Response(from: stream)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .application(.json))
            )
            assertEqual(response.contentLength, 28)
            assertEqual(response.bytes, ASCII("{'message': 'Hello, World!'}"))
            assertEqual(response.string, "{'message': 'Hello, World!'}")
        }
    }

    func testZeroContentLenght() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.contentLength, 0)
            assertNil(response.bytes)
            assertEqual(response.body, .none)
        }
    }

    func testChunked() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Transfer-Encoding: chunked\r\n" +
                "\r\n" +
                "d\r\n" +
                "Hello, World!\r\n" +
                "0\r\n" +
                "\r\n")
             let response = try Response(from: stream)
            assertEqual(response.string, "Hello, World!")
        }
    }
}
