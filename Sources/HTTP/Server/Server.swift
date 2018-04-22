/******************************************************************************
 *                                                                            *
 * Tris Foundation disclaims copyright to this source code.                   *
 * In place of a legal notice, here is a blessing:                            *
 *                                                                            *
 *     May you do good and not evil.                                          *
 *     May you find forgiveness for yourself and forgive others.              *
 *     May you share freely, never taking more than you give.                 *
 *                                                                            *
 ******************************************************************************
 *  This file contains code that has not yet been described                   *
 ******************************************************************************/

import Log
import Async
import Network
import Platform

public class Server: StreamingServer {
    public var bufferSize: Int

    let networkServer: Network.Server

    public let router = Router(middleware: [ErrorHandlerMiddleware.self])

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
        do {
            try process(stream: NetworkStream(socket: socket))
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
}
