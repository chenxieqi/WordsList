//
//  WordsListView.swift
//  LearnWords
//
//  Created by chen on 2020/07/05.
//  Copyright © 2020 chen. All rights reserved.
//

import SwiftUI

struct WordsListView: View {
    
    @State var document:DocumentContent = DocumentContent.init()
    
    var body: some View {
        VStack{
            ForEach(document.words, id: \.self){
                word in
                TranslateView()
            }
        }
    }
}

struct WordsListView_Previews: PreviewProvider {
    static var previews: some View {
        WordsListView()
    }
}
