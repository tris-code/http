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

extension Server {
    func process(_ request: Request) throws -> Response {
        let inputStreamTemp = OutputByteStream()
        try request.encode(to: inputStreamTemp)

        let inputStream = InputByteStream(inputStreamTemp.bytes)
        let outputStream = OutputByteStream()

        let byteStream = ByteStream(
            inputStream: inputStream,
            outputStream: outputStream)

        self.process(stream: byteStream)

        return try Response(from: InputByteStream(outputStream.bytes))
    }
}

class ApplicationTests: TestCase {
    func assertNoThrow(_ task: () throws -> Void) {
        do {
            try task()
        } catch {
            fail(String(describing: error))
        }
    }

    func testApplication() {
        assertNoThrow {
            var server = try Server(host: "127.0.0.1", port: 4301)

            var application = Application()

            application.route(get: "/test") {
                return Response(string: "test ok")
            }

            server.addApplication(application)

            let request = Request(url: "/test", method: .get)
            let response = try server.process(request)
            assertEqual(response.string, "test ok")
        }
    }

    func testApplicationBasePath() {
        assertNoThrow {
            var server = try Server(host: "127.0.0.1", port: 4302)

            var application = Application(basePath: "/v1")

            application.route(get: "/test") {
                return Response(string: "test ok")
            }

            server.addApplication(application)

            let request = Request(url: "/v1/test", method: .get)
            let response = try server.process(request)
            assertEqual(response.string, "test ok")
        }
    }

    func testApplicationMiddleware() {
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

        assertNoThrow {
            var server = try Server(host: "127.0.0.1", port: 4303)

            var application = Application(middleware: [FirstMiddleware.self])

            application.route(get: "/first") {
                return Response(string: "first ok")
            }

            application.route(
                get: "/first-second",
                middleware: [SecondMiddleware.self])
            {
                return Response(string: "first-second ok")
            }

            server.addApplication(application)

            let firstRequest = Request(url: "/first", method: .get)
            let firstResponse = try server.process(firstRequest)
            assertEqual(firstResponse.string, "first ok")
            assertEqual(firstResponse.headers["Middleware"], "first")
            assertEqual(firstResponse.headers["FirstMiddleware"], "true")

            let secondRequest = Request(url: "/first-second", method: .get)
            let secondResponse = try server.process(secondRequest)
            assertEqual(secondResponse.string, "first-second ok")
            assertEqual(secondResponse.headers["Middleware"], "first")
            assertEqual(secondResponse.headers["FirstMiddleware"], "true")
            assertEqual(secondResponse.headers["SecondMiddleware"], "true")
        }
    }


    static var allTests = [
        ("testApplication", testApplication),
        ("testApplicationBasePath", testApplicationBasePath),
        ("testApplicationMiddleware", testApplicationMiddleware),
    ]
}