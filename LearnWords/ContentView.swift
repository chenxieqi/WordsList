//
//  ContentView.swift
//  LearnWords
//
//  Created by chen on 2020/07/05.
//  Copyright © 2020 chen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var documentContent:DocumentContent
    
    var body: some View {
        VStack{
        //LanguageIdentificationView()
        DocumentScanView().environmentObject(documentContent)
        //Text("Home")
            NavigationLink(destination: TranslateView().environmentObject(documentContent)) {
                Text("Translate")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
