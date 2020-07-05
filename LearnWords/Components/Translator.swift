//
//  Translator.swift
//  LearnWords
//
//  Created by chen on 2020/07/05.
//  Copyright © 2020 chen. All rights reserved.
//

import Foundation
import FirebaseMLNLTranslate
class Translator{
    
    static func translateText(text:String)->String{
    let options = TranslatorOptions(sourceLanguage: .en, targetLanguage: .ja)
    let translator = NaturalLanguage.naturalLanguage().translator(options: options)
        
    let conditions = ModelDownloadConditions(
        allowsCellularAccess: false,
        allowsBackgroundDownloading: true
    )
        
    translator.downloadModelIfNeeded(with: conditions) { error in
        guard error == nil else { return }

        translator.translate(text) {
            translatedText, error in
            guard error == nil,
                let translatedText = translatedText else
            { return }
            
            translatedString = translatedText
            print(text)
            print(translatedString)
            print("//")
        }
      }
      return translatedString
    }
}
