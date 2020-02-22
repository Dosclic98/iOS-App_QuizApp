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
        questions.append(QstAnsw(type: .OAqst, qst: "Di che colore era il cavallo bianco di Napoleone", answ: ["Bianco"], correct: []))
        questions.append(QstAnsw(type: .SAqst, qst: "Qual'è la capitale d'Italia?", answ: ["Roma", "Milano", "Napoli", "Torino"], correct: [0]))
        questions.append(QstAnsw(type: .SAqst, qst: "Cosa significa la parola inglese needle?", answ: ["Filo", "Mento", "Ago", "Ginocchio"], correct: [2]))
        questions.append(QstAnsw(type: .SAqst, qst: "L'autore de 'I viaggi di Gulliver' è...", answ: ["Verga", "Swift", "Poe", "Svevo"], correct: [1]))
        questions.append(QstAnsw(type: .MAqst, qst: "Quali di questi Tropici non esistono?", answ: ["Capricorno", "Vergine", "Cancro", "Bilancia"], correct: [1, 3]))
        questions.append(QstAnsw(type: .MAqst, qst: "Quali di questi alberi non sono dei sempreverde?", answ: ["Pino silvestre", "Abete bianco", "Salice", "Pesco"], correct: [2, 3]))
        questions.append(QstAnsw(type: .OAqst, qst: "La valle dei Re si trova in...", answ: ["Egitto", "Africa"], correct: []))
        questions.append(QstAnsw(type: .MAqst, qst: "Quali dei seguenti nomi non sono di un tipo di nave?", answ: ["Catapecchia", "Cocca", "Albatros", "Metaniera"], correct: [0, 2]))
        questions.append(QstAnsw(type: .SAqst, qst: "Chi dipinse 'L'Ultima cena'?", answ: ["Leonardo Sciascia", "Leonardo da Vinci", "Il Giorgione", "Il Caravaggio"], correct: [1]))
        questions.append(QstAnsw(type: .OAqst, qst: "Quali animali tirano la slitta di Babbo Natale?", answ: ["Renna", "Renne"], correct: []))
        
        questions.shuffle()
    }
    
    public func shuffle() {
        questions.shuffle()
    }
    
    public func qstNumber() -> Int {
        return questions.count
    }
    
    public func getQst(_ index: Int) -> QstAnsw {
        return questions[index]
    }
    
}

