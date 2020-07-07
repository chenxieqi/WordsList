//
//  DocumentContent.swift
//  LearnWords
//
//  Created by chen on 2020/07/05.
//  Copyright © 2020 chen. All rights reserved.
//

import Foundation
import Combine

final class DocumentContent:ObservableObject {
    @Published var content:String = ""
    @Published var words:[String] = [""]
    @Published var translatedWords:[String] = [""]
}
