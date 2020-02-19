//
//  QuestionAnswerStruct.swift
//  QuizApp
//
//  Created by Davide Savarro on 19/02/2020.
//  Copyright © 2020 Davide Savarro. All rights reserved.
//

import Foundation

struct QstAnsw {
    var type: QstType
    var qst: String
    var answ: [String]
    var correct: [Int]
}
