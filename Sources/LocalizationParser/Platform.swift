//
//  Platform.swift
//  LocalizationParser
//
//  Created by Mikkel Sindberg Eriksen on 20/08/2018.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateFormatter
}()

/// An enum defining different platforms to localize for.
public enum Platform: String {

    /// The platform is an iOS device.
    case ios = "ios"

    /// The platform is an android device.
    case android = "android"

    /// The name of the localized outpput file for the platform.
    var localizedFileName: String {
        switch self {
        case .ios:
            return "Localizable.strings"
        case .android:
            return "strings.xml"
        }
    }

    /// The name of the output folder for the localized file for the platform.
    func localizedFolderName(for language: Language) -> String {
        // See (ios): https://stackoverflow.com/questions/3040677/locale-codes-for-iphone-lproj-folders
        // See (android): https://stackoverflow.com/questions/13693209/android-localization-values-folder-names/43359430#43359430
        switch self {
        case .ios:
            return "\(language.languageCode).lproj"
        case .android:
            return  "values-\(language.languageCode)"
        }
    }

    /// The header for the localized file for the platform.
    func localizedFileHeader(for language: Language) -> String {

        let date = dateFormatter.string(from: Date())
        let header = ""
            + "\t" + "\(localizedFileName)"
            + "\n"
            + "\n" + "\t" + "This file was created by LocalizationParser: https://github.com/foodlovers/localization_parser"
            + "\n"
            + "\n" + "\t" + "- Time: \(date)"
            + "\n" + "\t" + "- Platform: \(self.rawValue)"
            + "\n" + "\t" + "- Language: \(language.rawValue)"

        switch self {
        case .ios:
            return ""
                + "/*"
                + "\n"
                + header
                + "\n"
                + "*/"
                + "\n"
        case .android:
            return ""
                + "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                + "\n" + "<!-- "
                + "\n"
                + header
                + "\n" + "-->"
                + "\n"
                + "\n" + "<resources>"
                + "\n"
        }
    }

    /// The footer for the localized file for the platform.
    func localizedFileFooter() -> String {
        switch self {
        case .ios:
            return ""
        case .android:
            return "\n</resources>"
        }
    }

    /// A header with the given value formatted for the platform.
    func header(with value: String) -> String {
        switch self {
        case .ios: return "\n// \(value)\n"
        case .android: return "\n\t<!-- \(value) -->\n"
        }
    }

    /// A localized string with the given value and tag for the platform.
    func localizedString(with value: String, for tag: String) throws -> String {

        let formattedValue = try format(value: value)

        switch self {
        case .ios: return "\"\(tag)\" = \"\(formattedValue)\";\n"
        case .android: return "\t<string name=\"\(tag)\">\(formattedValue)</string>\n"
        }
    }

    func format(value: String) throws -> String {

        var formattedValue = value

        // Escape double quotes in the string, but ignore already escaped double quotes.
        formattedValue = try formattedValue.replacingOccurencesMatching(pattern: "(?<!\\\\)[\"]", with: "\\\\\"")

        switch self {
        case .ios:
            break
        case .android:
            // Escape single quotes in the string, but ignore already escaped single quotes.
            formattedValue = try formattedValue.replacingOccurencesMatching(pattern: "(?<!\\\\)[']", with: "\\\\\'")

            // Replace '<' with its html version.
            formattedValue = try formattedValue.replacingOccurencesMatching(pattern: "<", with: "&lt;")

            // Replace '>' with its html version.
            formattedValue = try formattedValue.replacingOccurencesMatching(pattern: ">", with: "&gt;")

            // Replace '...' with its html version.
            formattedValue = try formattedValue.replacingOccurencesMatching(pattern: "\\.\\.\\.", with: "&#8230;")

            // Replace '&' with its html version if it is not part of a HTML entity.
            formattedValue = try formattedValue.replacingOccurencesMatching(pattern: "&(?!(\\#[1-9]\\d{1,3}|[A-Za-z][0-9A-Za-z]+);)", with: "&amp;")
        }

        return formattedValue
    }
}
