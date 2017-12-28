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

class MiddlewareTests: TestCase {
    func testMiddleware() {
        struct TestMiddleware: Middleware {
            public static func createMiddleware(
                for handler: @escaping RequestHandler
            ) -> RequestHandler {
                return { request in
                    let response = try handler(request)
                    response.status = .ok
                    response.headers["Custom-Header"] = "Middleware"
                    return response
                }
            }
        }

        guard let server = try? Server(host: "127.0.0.1", port: 4200) else {
            fail()
            return
        }

        server.route(
            get: "/middleware",
            middleware: [TestMiddleware.self]
        ) {
            return Response(status: .internalServerError)
        }

        let request = "GET /middleware HTTP/1.1\r\n\r\n"

        let inputStream = InputByteStream([UInt8](request.utf8))
        let outputStream = OutputByteStream()

        let byteStream = ByteStream(
            inputStream: inputStream,
            outputStream: outputStream)

        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Custom-Header: Middleware\r\n" +
            "\r\n"

        server.process(stream: byteStream)

        let response = String(decoding: outputStream.bytes, as: UTF8.self)

        assertEqual(response, expected)
    }

    func testMiddlewareOrder() {
        struct FirstMiddleware: Middleware {
            public static func createMiddleware(
                for handler: @escaping RequestHandler
            ) -> RequestHandler {
                return { request in
                    let response = try handler(request)
                    response.headers["Middleware"] = "first"
                    response.headers["FirstMiddleware"] = "true"
                    return response
                }
            }
        }

        struct SecondMiddleware: Middleware {
            public static func createMiddleware(
                for handler: @escaping RequestHandler
            ) -> RequestHandler {
                return { request in
                    let response = try handler(request)
                    response.headers["Middleware"] = "second"
                    response.headers["SecondMiddleware"] = "true"
                    return response
                }
            }
        }

        guard let server = try? Server(host: "127.0.0.1", port: 4201) else {
            fail()
            return
        }

        server.route(
            get: "/middleware",
            middleware: [FirstMiddleware.self, SecondMiddleware.self]
        ) {
            return Response(status: .ok)
        }

        let request = "GET /middleware HTTP/1.1\r\n\r\n"

        let inputStream = InputByteStream([UInt8](request.utf8))
        let outputStream = OutputByteStream()

        let byteStream = ByteStream(
            inputStream: inputStream,
            outputStream: outputStream)

        server.process(stream: byteStream)

        let response = String(decoding: outputStream.bytes, as: UTF8.self)

        let lines = response.split(separator: "\r\n")

        let firstMiddleware = lines.first(where: {
            return $0.starts(with: "FirstMiddleware")
        })
        let secondMiddleware = lines.first(where: {
            return $0.starts(with: "SecondMiddleware")
        })
        let middleware = lines.first(where: {
            return $0.starts(with: "Middleware")
        })

        assertEqual(firstMiddleware, "FirstMiddleware: true")
        assertEqual(secondMiddleware, "SecondMiddleware: true")
        assertEqual(middleware, "Middleware: first")
    }


    static var allTests = [
        ("testMiddleware", testMiddleware),
        ("testMiddlewareOrder", testMiddlewareOrder),
    ]
}
