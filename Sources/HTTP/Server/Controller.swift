/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import JSON

public protocol Controller {
    static var basePath: String { get }
    static var middleware: [Middleware.Type] { get }
    static func setup(router: ControllerRouter<Self>) throws
}

public extension Controller {
    static var basePath: String {
        return ""
    }

    static var middleware: [Middleware.Type] {
        return []
    }
}

extension RouterProtocol {
    func addController<C: Controller>(
        _ controller: C.Type,
        constructor: @escaping () throws -> C
    ) throws {
        let router = ControllerRouter<C>(
            basePath: C.basePath,
            middleware: C.middleware,
            controllerConstructor: constructor
        )
        try C.setup(router: router)
        self.addApplication(router.application)
    }

    func check<T, C: Controller>(
        type: T.Type,
        for controller: C.Type
    ) throws {
        do {
            _ = try Services.shared.resolve(T.self)
        } catch let error as Services.Error {
            debugPrint(controller)
            throw error
        }
    }
}

public class ControllerRouter<T: Controller> {
    let application: Application
    var constructor: () throws -> T

    public init(
        basePath: String,
        middleware: [Middleware.Type],
        controllerConstructor: @escaping () throws -> T
    ) {
        application = Application(basePath: basePath, middleware: middleware)
        constructor = controllerConstructor
    }
}