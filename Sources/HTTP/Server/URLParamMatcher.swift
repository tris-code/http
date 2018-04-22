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

import Foundation

public struct URLParamMatcher {
    public let params: [(name: String, index: Int)]

    public init(_ url: String) {
        let components = url.components(separatedBy: "/")
        var params: [(name: String, index: Int)] = []
        let count = components.count
        for (index, item) in components.enumerated() {
            if item.hasPrefix(":") {
                let name = String(item[item.index(after: item.startIndex)...])
                params.append((name, count - index))
            }
        }
        self.params = params.reversed()
    }

    public func match(from url: String) -> [String : String] {
        var dictionary: [String : String] = [:]

        let scalars = url.unicodeScalars
        var endIndex = scalars.endIndex
        var startIndex = scalars.index(before: endIndex)

        var nextIndex = 1
        for param in params {
            while true {
                guard nextIndex <= param.index else {
                    break
                }

                while startIndex > scalars.startIndex &&
                    scalars[startIndex] != "/" {
                        startIndex = scalars.index(before: startIndex)
                }

                if nextIndex == param.index {
                    let value = scalars[startIndex..<endIndex].dropFirst()
                    dictionary[param.name] = String(value)
                }
                guard startIndex > scalars.startIndex else {
                    break
                }
                endIndex = startIndex
                startIndex = scalars.index(before: endIndex)
                nextIndex += 1
            }
        }
        return dictionary
    }
}
