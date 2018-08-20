import Foundation
import Commander

let main = command(

    Argument<String>("inputPath", description: "The path to the localization file to parse"),
    Argument<String>("outputPath", description: "The output path")
    ) { inputPath, outputPath in

        print(inputPath)
        print(outputPath)

        let delimiter = ";"

        do {
            let contents = try FileParser.readContents(from: URL(fileURLWithPath: inputPath))
            let cleanedContents = FileParser.clean(contents: contents)
            var table = FileParser.table(from: cleanedContents, using: delimiter)

            var firstRow = table.removeFirst()
            firstRow.removeFirst(2)
           // let languages = firstRow.map { Language(rawValue: $0)! } // TODO: do not explicitly unwrap

            do {
                try FileWriter.append(value: table[0][0], to: URL(fileURLWithPath: outputPath))
            } catch {
                print(error)
            }

        } catch {
            print(error)
        }



        /*
         for row in table where row.count > 0 {
         if row[0].hasPrefix("//") {
         write(header: row[0], for: languages)
         } else {
         var values = row
         let tag = values.removeFirst()
         let comment = values.removeFirst()
         write(values: values, for: languages, with: tag)
         }
         }
         */
    }

main.run()
