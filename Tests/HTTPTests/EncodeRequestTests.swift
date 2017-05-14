/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

@testable import HTTP

class EncodeRequestTests: TestCase {
    func testRequest() {
        let expected = "GET /test HTTP/1.1\r\n\r\n"
        let request = Request(method: .get, url: "/test")
        assertEqual(String(bytes: request.bytes), expected)
    }

    func testUrlQuery() {
        let expected = "GET /test?query=true HTTP/1.1\r\n\r\n"
        let request = Request(
            method: .get,
            url: URL(path: "/test", query: ["query" : "true"]))
        assertEqual(String(bytes: request.bytes), expected)
    }

    func testHost() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Host: 0.0.0.0:5000\r\n" +
            "\r\n"
        var request = Request()
        request.host = "0.0.0.0:5000"
        assertEqual(String(bytes: request.bytes), expected)
    }

    func testUserAgent() {
        let expected = "GET / HTTP/1.1\r\n" +
            "User-Agent: Mozilla/5.0\r\n" +
            "\r\n"
        var request = Request()
        request.userAgent = "Mozilla/5.0"
        assertEqual(String(bytes: request.bytes), expected)
    }

    func testAccept() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Accept: */*\r\n" +
            "\r\n"
        var request = Request()
        request.accept = "*/*"
        assertEqual(String(bytes: request.bytes), expected)
    }

    func testAcceptLanguage() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Accept-Language: en-US,en;q=0.5\r\n" +
            "\r\n"
        var request = Request()
        request.acceptLanguage = [
            AcceptLanguage(.enUS, priority: 1.0),
            AcceptLanguage(.en, priority: 0.5)
        ]
        assertEqual(String(bytes: request.bytes), expected)
    }

    func testAcceptEncoding() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Accept-Encoding: gzip,deflate\r\n" +
            "\r\n"
        var request = Request()
        request.acceptEncoding = [.gzip, .deflate]
        assertEqual(String(bytes: request.bytes), expected)
    }

    func testAcceptCharset() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Accept-Charset: ISO-8859-1,utf-7,utf-8;q=0.7,*;q=0.7\r\n" +
            "\r\n"
        var request = Request()
        request.acceptCharset = [
            AcceptCharset(.isoLatin1),
            AcceptCharset(.custom("utf-7")),
            AcceptCharset(.utf8, priority: 0.7),
            AcceptCharset(.any, priority: 0.7)
        ]
        assertEqual(String(bytes: request.bytes), expected)
    }

    func testKeepAlive() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Keep-Alive: 300\r\n" +
            "\r\n"
        var request = Request()
        request.keepAlive = 300
        assertEqual(String(bytes: request.bytes), expected)
    }

    func testConnection() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Connection: close\r\n" +
            "\r\n"
        var request = Request()
        request.connection = .close
        assertEqual(String(bytes: request.bytes), expected)
    }

    func testContentType() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Content-Type: text/plain\r\n" +
            "\r\n"
        var request = Request()
        request.contentType = .text
        assertEqual(String(bytes: request.bytes), expected)
    }

    func testContentLength() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        var request = Request()
        request.contentLength = 0
        assertEqual(String(bytes: request.bytes), expected)
    }

    func testTransferEncoding() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n"
        var request = Request()
        request.transferEncoding = [.chunked]
        assertEqual(String(bytes: request.bytes), expected)
    }

    func testCustomHeaders() {
        let expected = "GET / HTTP/1.1\r\n" +
            "User: guest\r\n" +
            "\r\n"
        var request = Request()
        request.headers["User"] = "guest"
        assertEqual(String(bytes: request.bytes), expected)
    }

    func testJsonInitializer() {
        let expected = "POST / HTTP/1.1\r\n" +
            "Content-Type: application/json\r\n" +
            "Content-Length: 27\r\n" +
            "\r\n" +
            "{\"message\":\"Hello, World!\"}"
        let values = ["message": "Hello, World!"]
        let request = try! Request(method: .post, url: "/", json: values)
        assertEqual(String(bytes: request.bytes), expected)
    }

    func testUrlEncodedInitializer() {
        let expected = "POST / HTTP/1.1\r\n" +
            "Content-Type: application/x-www-form-urlencoded\r\n" +
            "Content-Length: 23\r\n" +
            "\r\n" +
            "message=Hello,%20World!"
        let values = ["message": "Hello, World!"]
        let request = try! Request(method: .post, url: "/", urlEncoded: values)
        assertEqual(String(bytes: request.bytes), expected)
    }


    static var allTests = [
        ("testRequest", testRequest),
        ("testUrlQuery", testUrlQuery),
        ("testHost", testHost),
        ("testUserAgent", testUserAgent),
        ("testAccept", testAccept),
        ("testAcceptLanguage", testAcceptLanguage),
        ("testAcceptEncoding", testAcceptEncoding),
        ("testAcceptCharset", testAcceptCharset),
        ("testKeepAlive", testKeepAlive),
        ("testConnection", testConnection),
        ("testContentType", testContentType),
        ("testContentLength", testContentLength),
        ("testTransferEncoding", testTransferEncoding),
        ("testCustomHeaders", testCustomHeaders),
        ("testJsonInitializer", testJsonInitializer),
        ("testUrlEncodedInitializer", testUrlEncodedInitializer),
    ]
}
