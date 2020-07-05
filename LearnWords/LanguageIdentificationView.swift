//
//  LanguageIdentificationView.swift
//  LearnWords
//
//  Created by chen on 2020/07/05.
//  Copyright © 2020 chen. All rights reserved.
//

// Just for testing
import SwiftUI
import FirebaseMLNaturalLanguage


struct LanguageIdentificationView: View {
    
    @State var text:String = ""
    @State var languageIdentified:String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            TextField("Testing language", text: $text)
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
            Text(languageIdentified)
            Button(action: identifyLanguage,label:{
                Text("Identify")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
            })
        }
    }
    
    func identifyLanguage(){
        let languageId = NaturalLanguage.naturalLanguage().languageIdentification()

        languageId.identifyLanguage(for: text) { (languageCode, error) in
          if let error = error {
            print("Failed with error: \(error)")
            return
          }
          if let languageCode = languageCode, languageCode != "und" {
            self.languageIdentified = languageCode
          } else {
            self.languageIdentified = "No language was identified"
          }
        }
    }
}

struct LanguageIdentificationView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageIdentificationView()
    }
}

