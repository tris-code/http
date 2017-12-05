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
import Server
import Client
import Dispatch
import AsyncDispatch

class FunctionalTests: TestCase {
    override func setUp() {
        AsyncDispatch().registerGlobal()
    }

    func setup(
        port: UInt16,
        serverCode: @escaping (Server) throws -> Void,
        clientCode: @escaping (Client) throws -> Void
    ) {
        let semaphore = DispatchSemaphore(value: 0)

        async.task {
            do {
                let server =
                    try Server(host: "127.0.0.1", port: port)

                try serverCode(server)

                semaphore.signal()
                try server.start()
            } catch {
                async.loop.terminate()
                fail(String(describing: error))
            }
        }

        semaphore.wait()

        async.task {
            do {
                let client = try Client(host: "127.0.0.1", port: Int(port))
                try client.connect()

                try clientCode(client)

                async.loop.terminate()
            } catch {
                async.loop.terminate()
                fail(String(describing: error))
            }
        }
    
        async.loop.run()
    }

    func testRequest() {
        setup(
            port: 6000,
            serverCode: { server in
                server.route(get: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let request = Request(method: .get, url: "/")
                let response = try client.makeRequest(request)
                assertEqual(response.status, .ok)
                assertNil(response.body)
            }
        )
    }

    func testGet() {
        setup(
            port: 6001,
            serverCode: { server in
                server.route(get: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.get(path: "/")
                assertEqual(response.status, .ok)
                assertNil(response.body)
            }
        )
    }

    func testHead() {
        setup(
            port: 6002,
            serverCode: { server in
                server.route(head: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.head(path: "/")
                assertEqual(response.status, .ok)
                assertNil(response.body)
            }
        )
    }

    func testPost() {
        setup(
            port: 6003,
            serverCode: { server in
                server.route(post: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.post(path: "/")
                assertEqual(response.status, .ok)
                assertNil(response.body)
            }
        )
    }

    func testPut() {
        setup(
            port: 6004,
            serverCode: { server in
                server.route(put: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.put(path: "/")
                assertEqual(response.status, .ok)
                assertNil(response.body)
            }
        )
    }

    func testDelete() {
        setup(
            port: 6005,
            serverCode: { server in
                server.route(delete: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.delete(path: "/")
                assertEqual(response.status, .ok)
                assertNil(response.body)
            }
        )
    }

    func testOptions() {
        setup(
            port: 6006,
            serverCode: { server in
                server.route(options: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.options(path: "/")
                assertEqual(response.status, .ok)
                assertNil(response.body)
            }
        )
    }

    func testAll() {
        setup(
            port: 6007,
            serverCode: { server in
                server.route(all: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let getResponse = try client.get(path: "/")
                assertEqual(getResponse.status, .ok)

                let headResponse = try client.head(path: "/")
                assertEqual(headResponse.status, .ok)

                let postResponse = try client.post(path: "/")
                assertEqual(postResponse.status, .ok)

                let putResponse = try client.put(path: "/")
                assertEqual(putResponse.status, .ok)

                let deleteResponse = try client.delete(path: "/")
                assertEqual(deleteResponse.status, .ok)

                let optionsResponse = try client.post(path: "/")
                assertEqual(optionsResponse.status, .ok)
            }
        )
    }

    func testJson() {
        setup(
            port: 6008,
            serverCode: { server in
                struct Model: Codable {
                    var message: String
                }
                server.route(post: "/") { (model: Model) in
                    assertEqual(model.message, "Hello, Server!")
                    return Model(message: "Hello, Client!")
                }
            },
            clientCode: { client in
                let message = ["message": "Hello, Server!"]
                let response = try client.post(path: "/", object: message)
                assertEqual(response.status, .ok)
                assertEqual(response.body, "{\"message\":\"Hello, Client!\"}")
            }
        )
    }

    func testFormEncoded() {
        setup(
            port: 6009,
            serverCode: { server in
                struct Model: Decodable {
                    var message: String
                }
                server.route(post: "/") { (model: Model) in
                    assertEqual(model.message, "Hello, Server!")
                    return try Response(
                        body: ["message": "Hello, Client!"],
                        contentType: .urlEncoded)
                }
            },
            clientCode: { client in
                struct Query: Encodable {
                    let message = "Hello, Server!"
                }
                let response = try client.post(
                    path: "/",
                    object: Query(),
                    contentType: .urlEncoded)
                assertEqual(response.status, .ok)
                assertEqual(response.body, "message=Hello,%20Client!")
            }
        )
    }


    static var allTests = [
        ("testRequest", testRequest),
        ("testGet", testGet),
        ("testHead", testHead),
        ("testPost", testPost),
        ("testPut", testPut),
        ("testDelete", testDelete),
        ("testOptions", testOptions),
        ("testAll", testAll),
        ("testJson", testJson),
        ("testFormEncoded", testFormEncoded),
    ]
}
