//
//  LocalizationWriter.swift
//  LocalizationParser
//
//  Created by Mikkel Sindberg Eriksen on 20/08/2018.
//

import Foundation

public final class LocalizationWriter {

    public static func write(localization: Localization, relativeTo path: URL) throws {

        let filePath = self.filePath(for: localization, relativeTo: path)

        let fileHeader = localization.platform.localizedFileHeader(for: localization.language)
        try append(value: fileHeader, to: filePath)

        for content in localization.contents {
            switch content {
            case .header(let value):
                let header = localization.platform.header(with: value)
                try append(value: header, to: filePath)
            case .localizedString(let tag, let value):
                let localizedString = try localization.platform.localizedString(with: value, for: tag)
                try append(value: localizedString, to: filePath)
            }
        }

        let fileFooter = localization.platform.localizedFileFooter()
        try append(value: fileFooter, to: filePath)
    }

    private static func filePath(for localization: Localization, relativeTo path: URL) -> URL {
        return path
            .appendingPathComponent(localization.platform.rawValue)
            .appendingPathComponent(localization.platform.localizedFolderName(for: localization.language))
            .appendingPathComponent(localization.platform.localizedFileName)
    }

    private static func append(value: String, to filePath: URL, encoding: String.Encoding = .utf8) throws {
        if let fileHandle = try? FileHandle(forWritingTo: filePath) {
            if let data = value.data(using: encoding) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            } else {
                throw ParseError.error("Failed to convert string with value: '\(value)' to data.")
            }
        } else {
            let folderPath = filePath.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
            try value.write(to: filePath, atomically: true, encoding: encoding)
        }
    }
}
