//
//  String+Regex.swift
//  Commander
//
//  Created by Mikkel Sindberg Eriksen on 23/08/2018.
//

import Foundation

extension String {

    /// Replaces occurrances matching the given regex pattern with the given value.
    public func replacingOccurencesMatching(pattern: String, with value: String) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        return regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.count), withTemplate: value)
    }
}
