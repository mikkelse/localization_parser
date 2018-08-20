//
//  FileWriter.swift
//  Commander
//
//  Created by Mikkel Sindberg Eriksen on 20/08/2018.
//

import Foundation

public final class FileWriter {

    public static func write(header: String, for languages: [Language], platform: Platform) {
        for language in languages {
            writeLine(with: header, for: language)
        }
    }

    public static func write(values: [String], for tag: String, languages: [Language], platform: Platform) {
        for (index, language) in languages.enumerated() {
            let value = values[index]
            if value.count > 0 {
                writeLine(with: "\(tag) = \(value)", for: language)
            } else {
                print("Warning: tag '\(tag)' missing value for language '\(language)'")
            }
        }
    }

    public static func writeLine(with value: String, for language: Language) {
        print("LANGUAGE: '\(language)': \(value)")
    }

    public static func append(value: String, to filePath: URL, encoding: String.Encoding = .utf8) throws {
        if let fileHandle = try? FileHandle(forWritingTo: filePath) {
            if let data = value.data(using: encoding) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            } else {
                print("Failed to write value: \(value)")
            }
        } else {
            try value.write(to: filePath, atomically: true, encoding: encoding)
        }
    }
}
