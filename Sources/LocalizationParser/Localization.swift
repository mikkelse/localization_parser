//
//  Localization.swift
//  Commander
//
//  Created by Mikkel Sindberg Eriksen on 22/08/2018.
//

import Foundation

/// A struct representing a localization in a specific language for a specific platform.
public struct Localization {

    /// The platform of the localization.
    let platform: Platform

    /// The language of the localization.
    let language: Language

    /// The contents of the localization.
    let contents: [LocalizationContent]
}

/// An enum defining content for a localization.
public enum LocalizationContent {

    /// An enum defining errors relating to parsing localization content.
    enum Error: Swift.Error {

        /// The tag is missing for the given value.
        case missingTag(String)

        /// The values is missing for the given tag.
        case missingValue(String)
    }

    /// The content is a header.
    case header(String)

    /// The content is a localized string with the given tag and value.
    case localizedString(tag: String, value: String)

    /// The localization content for the given platform and language column value.
    static func content(from platformColumnValue: String, languageColumnValue: String) throws -> LocalizationContent {

        let headerMarkup = "#"

        if platformColumnValue.hasPrefix(headerMarkup) {
            let header = String(platformColumnValue.dropFirst(headerMarkup.count))
            let trimmedHeader = header.trimmingCharacters(in: .whitespacesAndNewlines)
            return .header(trimmedHeader)
        } else {
            let trimmedTag = platformColumnValue.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedLocalization = languageColumnValue.trimmingCharacters(in: .whitespacesAndNewlines)
            guard trimmedTag.count > 0 else { throw Error.missingTag(languageColumnValue) }
            guard trimmedLocalization.count > 0 else { throw Error.missingValue(platformColumnValue) }
            return .localizedString(tag: trimmedTag, value: trimmedLocalization)
        }
    }
}
