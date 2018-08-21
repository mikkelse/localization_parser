//
//  LocalizationParser.swift
//  LocalizationParser
//
//  Created by Mikkel Sindberg Eriksen on 20/08/2018.
//

import Foundation

public struct Localization {
    let platform: Platform
    let language: Language
    let contents: [LocalizationContent]
}

public enum LocalizationContent {
    case header(String)
    case localizedString(tag: String, value: String)

    static func content(from platformValue: String, languageValue: String) -> LocalizationContent? {

        let headerMarkup = "//"

        if platformValue.hasPrefix(headerMarkup) {
            let header = String(platformValue.dropFirst(headerMarkup.count))
            let trimmedHeader = header.trimmingCharacters(in: .whitespacesAndNewlines)
            return .header(trimmedHeader)
        } else {
            let trimmedTag = platformValue.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedLocalization = languageValue.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedTag.count > 0 && trimmedLocalization.count > 0 {
                return .localizedString(tag: trimmedTag, value: trimmedLocalization)
            }
        }

        return nil
    }
}

public final class LocalizationParser {

    static func localizations(from contents: String, using delimiter: String = ";") throws -> [Localization] {

        var rows = contents.components(separatedBy: "\n")

        if !rows.isEmpty {
            let firstRow = rows.removeFirst()
            let columns = firstRow.components(separatedBy: delimiter)
            let columnDefinitions = try ColumnDefinition.definitions(from: columns)
            var localizations = [Localization]()

            for (platformIndex, definition) in columnDefinitions.enumerated() {
                if case .platform(let platform) = definition {
                    for (languageIndex, definition) in columnDefinitions.enumerated() {
                        if case .language(let language) = definition {

                            var contents = [LocalizationContent]()
                            for row in rows {
                                let elements = row.components(separatedBy: delimiter)
                                if let content = LocalizationContent.content(from: elements[platformIndex], languageValue: elements[languageIndex]) {
                                    contents.append(content)
                                }
                            }

                            let localization = Localization(platform: platform, language: language, contents: contents)
                            localizations.append(localization)

                        }
                    }
                }
            }

            return localizations
        } else {
            throw ParseError.error("Could not parse table from contents: \(contents)")
        }

    }
}




public final class FileParser {


     public static func parseContents(from path: URL) throws -> String {
        let contents = try readContents(from: path)
        return clean(contents: contents)
     }

     private static func readContents(from path: URL) throws ->  String {
        return try String(contentsOf: path)
     }

     private static func clean(contents: String) -> String {
        return contents.replacingOccurrences(of: "\r", with: "")
     }

}
