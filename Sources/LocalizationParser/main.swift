import Foundation
import Commander

let main = command(

    Argument<String>("inputPath", description: "The path to the localization file to parse"),
    Argument<String>("outputPath", description: "The output path")
    ) { inputPath, outputPath in

        do {
            let contents = try FileParser.parseContents(from: URL(fileURLWithPath: inputPath))
            let localizations = try LocalizationParser.localizations(from: contents)
            for localization in localizations {
                FileWriter.write(localization: localization, to: URL(fileURLWithPath: outputPath))
            }
            
        } catch {
            print(error)
        }
    }

main.run()
