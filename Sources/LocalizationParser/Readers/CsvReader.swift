//
//  CsvReader.swift
//  Commander
//
//  Created by Mikkel Sindberg Eriksen on 22/08/2018.
//

import Foundation

/// A protocol defining an interface for reading a localization table.
protocol LocalizationFileReading {

    func readTable() throws -> [[String]]
}

/// An implementation of LocalizationFileReading for reading CSV files.
public final class CsvReader: LocalizationFileReading {

    private let contents: String
    private let delimiter: String

    init(contents: String, delimiter: String) {
        self.contents = contents
        self.delimiter = delimiter
    }

    func readTable() throws -> [[String]] {

        let parser = CSwiftV(with: contents, separator: delimiter)

        // Convert pairs of double quotes to single double quotes.
        // CSV escapes double quotes by turning them into pairs of double quotes.
        // Here we revert that to come back to the intended value.
        let rows = parser.rows.map {
            $0.map { $0.replacingOccurrences(of: "\"\"", with: "\"") }
        }

        return [parser.headers] + rows
    }
}
