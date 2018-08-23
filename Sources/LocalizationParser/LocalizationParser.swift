//
//  LocalizationParser.swift
//  LocalizationParser
//
//  Created by Mikkel Sindberg Eriksen on 20/08/2018.
//

import Foundation

public final class LocalizationParser {

    static func localizations(from table: [[String]]) throws -> [Localization] {

        var localizationTable = table

        if !table.isEmpty {
            
            let firstRow = localizationTable.removeFirst()
            let columnDefinitions = try ColumnDefinition.definitions(from: firstRow)

            var localizations = [Localization]()

            for (platformColumnIndex, definition) in columnDefinitions.enumerated() {
                if case .platform(let platform) = definition {
                    for (languageColumnIndex, definition) in columnDefinitions.enumerated() {
                        if case .language(let language) = definition {

                            var contents = [LocalizationContent]()
                            for row in localizationTable {
                                do {
                                    let content = try LocalizationContent.content(from: row[platformColumnIndex], languageColumnValue: row[languageColumnIndex])
                                    contents.append(content)
                                } catch {
                                    // Ignore errors for now.
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
            throw ParseError.error("Table is empty")
        }
    }
}


