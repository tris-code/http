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
@testable import HTTP

import struct Foundation.Date

class DecodeResponseTests: TestCase {
    func testOk() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.status, .ok)
        } catch {
            fail(String(describing: error))
        }
    }

    func testNotFound() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 404 Not Found\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.status, .notFound)
        } catch {
            fail(String(describing: error))
        }
    }

    func testMoved() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 301 Moved Permanently\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.status, .moved)
        } catch {
            fail(String(describing: error))
        }
    }

    func testBad() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 400 Bad Request\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.status, .badRequest)
        } catch {
            fail(String(describing: error))
        }
    }

    func testUnauthorized() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 401 Unauthorized\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.status, .unauthorized)
        } catch {
            fail(String(describing: error))
        }
    }

    func testInternalServerError() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 500 Internal Server Error\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.status, .internalServerError)
        } catch {
            fail(String(describing: error))
        }
    }

    func testContentType() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/plain\r\n" +
                "Content-Length: 0\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            let expected = ContentType(mediaType: .text(.plain))
            assertEqual(response.contentType, expected)
        } catch {
            fail(String(describing: error))
        }
    }

    func testConnection() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Connection: close\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.connection, .close)
        } catch {
            fail(String(describing: error))
        }
    }

    func testContentEncoding() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Content-Encoding: gzip, deflate\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.contentEncoding ?? [], [.gzip, .deflate])
        } catch {
            fail(String(describing: error))
        }
    }

    func testTransferEncoding() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Transfer-Encoding: gzip, chunked\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.transferEncoding ?? [], [.gzip, .chunked])
        } catch {
            fail(String(describing: error))
        }
    }

    func testCustomHeader() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "User: guest\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.headers["User"], "guest")
        } catch {
            fail(String(describing: error))
        }
    }

    func testStringResponse() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/plain\r\n" +
                "Content-Length: 5\r\n" +
                "\r\n" +
                "Hello")
            let response = try Response(from: bytes)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .text(.plain))
            )
            assertEqual(response.contentLength, 5)
            guard let rawBody = response.rawBody else {
                fail("body is nil")
                return
            }
            assertEqual(rawBody, ASCII("Hello"))
            assertEqual(response.body, "Hello")
        } catch {
            fail(String(describing: error))
        }
    }

    func testHtmlResponse() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/html\r\n" +
                "Content-Length: 13\r\n" +
                "\r\n" +
                "<html></html>")
            let response = try Response(from: bytes)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .text(.html))
            )
            assertEqual(response.contentLength, 13)
            guard let rawBody = response.rawBody else {
                fail("body is nil")
                return
            }
            assertEqual(rawBody, ASCII("<html></html>"))
            assertEqual(response.body, "<html></html>")
        } catch {
            fail(String(describing: error))
        }
    }

    func testBytesResponse() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: application/stream\r\n" +
                "Content-Length: 3\r\n" +
                "\r\n") + [1,2,3]
            let response = try Response(from: bytes)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .application(.stream))
            )
            assertEqual(response.contentLength, 3)
            guard let rawBody = response.rawBody else {
                fail("body is nil")
                return
            }
            assertEqual(rawBody, [1,2,3] as [UInt8])
        } catch {
            fail(String(describing: error))
        }
    }

    func testJsonResponse() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: application/json\r\n" +
                "Content-Length: 28\r\n" +
                "\r\n" +
                "{'message': 'Hello, World!'}")
            let response = try Response(from: bytes)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .application(.json))
            )
            assertEqual(response.contentLength, 28)
            guard let rawBody = response.rawBody else {
                fail("body is nil")
                return
            }
            assertEqual(rawBody, ASCII("{'message': 'Hello, World!'}"))
            assertEqual(response.body, "{'message': 'Hello, World!'}")
        } catch {
            fail(String(describing: error))
        }
    }

    func testZeroContentLenght() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.contentLength, 0)
            assertNil(response.rawBody)
            assertNil(response.body)
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookie() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.setCookie, [
                Response.SetCookie(Cookie(name: "username", value: "tony"))
                ])
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookieExpires() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; " +
                    "Expires=Wed, 21 Oct 2015 07:28:00 GMT\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.setCookie, [
                Response.SetCookie(
                    Cookie(name: "username", value: "tony"),
                    expires: Date(timeIntervalSinceReferenceDate: 467105280))
                ])
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookieMaxAge() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; Max-Age=42\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.setCookie, [
                Response.SetCookie(
                    Cookie(name: "username", value: "tony"),
                    maxAge: 42)
                ])
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookieHttpOnly() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; HttpOnly\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.setCookie, [
                Response.SetCookie(
                    Cookie(name: "username", value: "tony"),
                    httpOnly: true)
                ])
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookieSecure() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; Secure\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.setCookie, [
                Response.SetCookie(
                    Cookie(name: "username", value: "tony"),
                    secure: true)
                ])
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookieDomain() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; Domain=somedomain.com\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.setCookie, [
                Response.SetCookie(
                    Cookie(name: "username", value: "tony"),
                    domain: "somedomain.com")
                ])
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookiePath() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; Path=/\r\n" +
                "\r\n")
            let response = try Response(from: bytes)
            assertEqual(response.setCookie, [
                Response.SetCookie(
                    Cookie(name: "username", value: "tony"),
                    path: "/")
                ])
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookieManyValues() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Set-Cookie: num=0; Path=/; Max-Age=42; Secure; HttpOnly\r\n" +
                "Set-Cookie: key=value; Secure; HttpOnly\r\n" +
                "Set-Cookie: date=; Expires=Thu, 06-Sep-18 12:41:14 GMT\r\n" +
                "Set-Cookie: date=; Expires=Thu, 06 Sep 2018 12:41:14 GMT\r\n" +
                "\r\n")
            let response = try Response(from: bytes)

            assertEqual(response.setCookie[0],
                        Response.SetCookie(
                            Cookie(name: "num", value: "0"),
                            path: "/",
                            maxAge: 42,
                            secure: true,
                            httpOnly: true))

            assertEqual(response.setCookie[1],
                        Response.SetCookie(
                            Cookie(name: "key", value: "value"),
                            secure: true,
                            httpOnly: true))

            assertEqual(response.setCookie[2],
                        Response.SetCookie(
                            Cookie(name: "date", value: ""),
                            expires: Date(timeIntervalSince1970: 1536237674.0)))

            assertEqual(response.setCookie[3],
                        Response.SetCookie(
                            Cookie(name: "date", value: ""),
                            expires: Date(timeIntervalSince1970: 1536237674.0)))

        } catch {
            fail(String(describing: error))
        }
    }


    static var allTests = [
        ("testOk", testOk),
        ("testNotFound", testNotFound),
        ("testMoved", testMoved),
        ("testBad", testBad),
        ("testUnauthorized", testUnauthorized),
        ("testInternalServerError", testInternalServerError),
        ("testContentType", testContentType),
        ("testConnection", testConnection),
        ("testContentEncoding", testContentEncoding),
        ("testTransferEncoding", testTransferEncoding),
        ("testCustomHeader", testCustomHeader),
        ("testStringResponse", testStringResponse),
        ("testHtmlResponse", testHtmlResponse),
        ("testBytesResponse", testBytesResponse),
        ("testZeroContentLenght", testZeroContentLenght),
        ("testSetCookie", testSetCookie),
        ("testSetCookieExpires", testSetCookieExpires),
        ("testSetCookieMaxAge", testSetCookieMaxAge),
        ("testSetCookieHttpOnly", testSetCookieHttpOnly),
        ("testSetCookieSecure", testSetCookieSecure),
        ("testSetCookieDomain", testSetCookieDomain),
        ("testSetCookiePath", testSetCookiePath),
        ("testSetCookieManyValues", testSetCookieManyValues),
    ]
}
