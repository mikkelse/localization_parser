//
//  ColumnDefinition.swift
//  LocalizationParser
//
//  Created by Mikkel Sindberg Eriksen on 21/08/2018.
//

import Foundation

/// An enum defining the different columns of a table.
public enum ColumnDefinition {

    /// The string identifying a column definition.
    static let ColumnDefinitionIdentifier = "#"

    /// The column contains localized string tags for the given platform.
    case platform(Platform)

    /// The column contains localized values for the given language.
    case language(Language)

    /// The column contains comments for the localized value.
    case comment

    static func definition(from value: String) throws -> ColumnDefinition? {

        guard value.hasPrefix(ColumnDefinitionIdentifier) else { return nil }

        let definition = String(value.dropFirst())
        let definitionPair = definition.components(separatedBy: ":")

        switch definitionPair.first {
        case "platform":
            if let platformName = definitionPair.last, let platform = Platform(rawValue: platformName) {
                return .platform(platform)
            } else {
                throw ParseError.error("Could not parse 'platform' column definition from value: \(value)")
            }
        case "comment":
            if definitionPair.count == 1 {
                return .comment
            } else {
                throw ParseError.error("Could not parse 'comment' column definition from value: \(value)")
            }
        case "language":
            if let languageName = definitionPair.last, let language = Language(rawValue: languageName) {
                return .language(language)
            } else {
                throw ParseError.error("Could not parse 'language' column definition from value: \(value)")
            }
        default :
            throw ParseError.error("Could not parse column definition from value: \(value)")
        }
    }

    static func definitions(from values: [String]) throws -> [ColumnDefinition] {
        var definitions = [ColumnDefinition]()
        for value in values {
            if let definition = try ColumnDefinition.definition(from: value) {
                definitions.append(definition)
            }
        }
        return definitions
    }
}
