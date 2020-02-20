//
//  Questions.swift
//  QuizApp
//
//  Created by Davide Savarro on 19/02/2020.
//  Copyright © 2020 Davide Savarro. All rights reserved.
//

import Foundation
class Questions {
    private var questions = Array<QstAnsw>()

    public func qstInitializer() {
        questions.append(QstAnsw(type: .SAqst, qst: "Qual'è la capitale d'Italia", answ: ["Roma", "Milano", "Napoli", "Torino"], correct: [0]))
        questions.append(QstAnsw(type: .SAqst, qst: "Cosa significa la parola inglese needle", answ: ["Filo", "Mento", "Ago", "Ginocchio"], correct: [2]))
        questions.append(QstAnsw(type: .SAqst, qst: "L'autore de 'I viaggi di Gulliver' è...", answ: ["Verga", "Swift", "Poe", "Svevo"], correct: [1]))

    }
    
    public func qstNumber() -> Int {
        return questions.count
    }
    
    public func getQst(_ index:Int) -> QstAnsw {
        return questions[index]
    }
    
}

