//
//  Language.swift
//  LocalizationParser
//
//  Created by Mikkel Sindberg Eriksen on 20/08/2018.
//

import Foundation

/// An enum defining different languages for localization
public enum Language: String {
    
    case danish = "dk"
    case swedish = "se"
    case english = "uk"

    /// The ISO 639-1 language code for the language, i.e. "da", "en", "sv" etc.
    var languageCode: String {
        switch self {
        case .danish:
            return "da"
        case .swedish:
            return "sv"
        case .english:
            return "en"
        }
    }
}
