//
//  TranslateView.swift
//  LearnWords
//
//  Created by chen on 2020/07/05.
//  Copyright © 2020 chen. All rights reserved.
//

import SwiftUI
import FirebaseMLNLTranslate

struct TranslateView: View {
    
    @EnvironmentObject var documentContent:DocumentContent
    
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            Text(documentContent.content)
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
            Text(documentContent.translatedWords[0])
            Button(action:translateText,label:{
                Text("Translate")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
            })
        }
    }
    
    func translateText(){
    let options = TranslatorOptions(sourceLanguage: .en, targetLanguage: .ja)
    let translator = NaturalLanguage.naturalLanguage().translator(options: options)
        
    let conditions = ModelDownloadConditions(
        allowsCellularAccess: false,
        allowsBackgroundDownloading: true
    )
        
    translator.downloadModelIfNeeded(with: conditions) { error in
        guard error == nil else { return }

        translator.translate(self.documentContent.content) {
            translatedText, error in
            guard error == nil,
                let translatedText = translatedText else
            { return }
            
            self.documentContent.translatedWords[0] = translatedText
        }
      }
    }
}
/*
struct TranslateView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateView()
    }
}
*/
