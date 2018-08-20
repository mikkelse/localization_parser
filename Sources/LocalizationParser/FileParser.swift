//
//  FileParser.swift
//  Commander
//
//  Created by Mikkel Sindberg Eriksen on 20/08/2018.
//

import Foundation

public final class FileParser {

    public static func readContents(from path: URL) throws ->  String {
        return try String(contentsOf: path)
    }

    public static func clean(contents: String) -> String {
        return contents.replacingOccurrences(of: "\r", with: "")
    }

    public static func table(from contents: String, using delimiter: String) -> [[String]] {
        var result: [[String]] = []
        let rows = contents.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: delimiter)
            result.append(columns)
        }
        return result
    }
}
