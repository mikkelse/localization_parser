import Foundation
import Commander

enum ParseError: Error, LocalizedError {
    case error(String)

    public var errorDescription: String? {
        switch self {
        case .error(let message):
            return message
        }
    }
}

let main = command(

    Argument<String>("input", description: "The path to the localization file to parse."),
    Argument<String>("output", description: "The path to the location to put the localized files."),
    Option("delimiter", default: ",", description: "The delimiter to use when parsing the localization file.")

    ) { input, output, delimiter in

        do {

            let inputPath = URL(fileURLWithPath: input)
            let outputPath = URL(fileURLWithPath: output)
            let contents = try String(contentsOf: inputPath)

            var reader: LocalizationFileReading

            switch inputPath.pathExtension {
            case "csv":
                reader = CsvReader(contents: contents, delimiter: delimiter)
            default:
                throw ParseError.error("Unsupported file format: '\(inputPath.pathExtension)'. The parser currently only support '.csv' files.")
            }

            let table = try reader.readTable()
            let localizations = try LocalizationParser.localizations(from: table)

            for localization in localizations {
                try LocalizationWriter.write(localization: localization, relativeTo: outputPath)
            }
            
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }

main.run()
