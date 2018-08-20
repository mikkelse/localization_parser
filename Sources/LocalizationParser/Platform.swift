//
//  Platform.swift
//  Commander
//
//  Created by Mikkel Sindberg Eriksen on 20/08/2018.
//

import Foundation

public enum Platform: String {
    case ios = "ios"
    case android = "android"

    func header(with value: String) -> String {
        switch self {
        case .ios: return "// \(value)"
        case .android: return "<!-- \(value) -->"
        }
    }

    func localizedString(with value: String, for tag: String) -> String {
        switch self {
        case .ios: return "\(tag) = \(value)"
        case .android: return "<string name=\"\(tag)\">\(value)</string>"
        }
    }
}
