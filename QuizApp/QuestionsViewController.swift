//
//  QuestionsViewController.swift
//  QuizApp
//
//  Created by Davide Savarro on 19/02/2020.
//  Copyright © 2020 Davide Savarro. All rights reserved.
//

import Foundation
import UIKit

let nextErr: String = "Seleziona una risposta prima di verificare"
let checkErr: String = "Inserisci una risposta prima di controllarla"
let nxtBtnTxt: String = "Prossima"

let qstLabFin: String = "Punteggio finale: "
let finTxt: String = "Fine"
let checkBefProx: String = "Controlla la domanda prima di procedere"
let wrAnsHereHint: String = "Scrivi la risposta qui..."
let scoreTxt: String = "Score: "

var qst = Questions()
var currQstIndx = 0
var currScore = 0
var correctAnsSound: SoundPlayer = SoundPlayer(named: "correctAns")
var wrongAnsSound: SoundPlayer = SoundPlayer(named: "wrongAns")
var finishSound: SoundPlayer = SoundPlayer(named: "finish")

var selected: [Bool] = [false, false, false, false]

class QuestionViewController: UIViewController {

    @IBOutlet weak var numbQstLab: UILabel!
    @IBOutlet weak var scoreLab: UILabel!
    @IBOutlet weak var qstLab: UILabel!
    
    // Risposte
    
    @IBOutlet weak var firstAns: RoundButton!
    @IBOutlet weak var secAns: RoundButton!
    @IBOutlet weak var thirdAns: RoundButton!
    @IBOutlet weak var fourthAns: RoundButton!
    @IBOutlet weak var openAns: UITextField!
    
    @IBOutlet weak var restartBtn: RoundButton!
    @IBOutlet weak var checkBtn: RoundButton!
    @IBOutlet weak var nextBtn: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardHideTap()
        qst.qstInitializer()
        printQstNum(currQstIndx + 1)
        updateScore(currScore)
        setQstAns(qst.getQst(currQstIndx))
    }
    
    @IBAction func firstAnsSel(_ sender: Any) { selUnsel(0) }
    
    @IBAction func secAnsSel(_ sender: Any) { selUnsel(1) }
    
    @IBAction func thirdAnsSel(_ sender: Any) { selUnsel(2) }
    
    @IBAction func fourthAnsSel(_ sender: Any) { selUnsel(3) }
    
    @IBAction func checkAct(_ sender: Any) {
        let qstAns = qst.getQst(currQstIndx)
        if(qstAns.type == QstType.SAqst || qstAns.type == QstType.MAqst) {
            if(somethingSelected()) {
                if(rightAnsw(qstAns.correct)) {
                    currScore += 1
                    correctAnsSound.play()
                } else {
                    wrongAnsSound.play()
                }
                updateScore(currScore);
                disableAnsCheckBtn()
            } else {
                showToast(message: nextErr, font: UIFont.systemFont(ofSize: 20))
            }
        } else if(qstAns.type == QstType.OAqst) {
            let answer: String? = openAns.text
            if(answer == "") {
                showToast(message: checkErr, font: UIFont.systemFont(ofSize: 20))
            } else {
                if(openQstRight(answer!, qstAns.answ)) {
                    currScore += 1
                    correctAnsSound.play()
                } else {
                    wrongAnsSound.play()
                }
                updateScore(currScore);
                disableAnsCheckBtn()
            }
            
        } else {
            print("Malformed question")
        }
    }
    
    @IBAction func restartAct(_ sender: Any) {
        enableScoreQstLab()
        qst.shuffle()
        qstLab.backgroundColor = UIColor.white
        nextBtn.setTitle(nxtBtnTxt, for: .normal)
        currQstIndx = 0
        currScore = 0
        printQstNum(currQstIndx + 1)
        updateScore(currScore)
        resetSelected()
        unselectAllBtn()
        setQstAns(qst.getQst(currQstIndx))
    }
    
    @IBAction func nextAct(_ sender: Any) {
        if(!checkBtn.isEnabled) {
            currQstIndx += 1
            printQstNum(currQstIndx + 1)
            if(currQstIndx == qst.qstNumber()) {
                // siamo oltre la fine, si mostra il risultato e si
                // propone di ricominciare
                showEnableRestartBtn()
                disableAllAnsCounters()
                qstLab.backgroundColor = UIColor.systemOrange
                qstLab.text = qstLabFin + String(currScore)
                finishSound.play()
            }
            else if(currQstIndx <= (qst.qstNumber() - 1)) {
                if(currQstIndx == (qst.qstNumber() - 1)) {
                    nextBtn.setTitle(finTxt, for: .normal)
                }
                resetSelected()
                unselectAllBtn()
                setQstAns(qst.getQst(currQstIndx))
            }
        } else {
            showToast(message: checkBefProx, font: UIFont.systemFont(ofSize: 20))
        }
    }
    
    func showEnableRestartBtn() {
        checkBtn.isEnabled = false
        checkBtn.isHidden = true
        nextBtn.isEnabled = false
        nextBtn.isHidden = true
        
        restartBtn.isEnabled = true
        restartBtn.isHidden = false
    }
    
    func disableAllAnsCounters() {
        // Disabilito e nescondo la parte di risposta chiusa
        firstAns.isHidden = true
        firstAns.isEnabled = false
        secAns.isHidden = true
        secAns.isEnabled = false
        thirdAns.isHidden = true
        thirdAns.isEnabled = false
        fourthAns.isHidden = true
        fourthAns.isEnabled = false
        
        //Disabilito la parte di risposta aperta
        openAns.isHidden = true
        openAns.isEnabled = false
        
        scoreLab.isHidden = true
        scoreLab.isEnabled = false
        numbQstLab.isHidden = true
        numbQstLab.isEnabled = false
        
        
    }
    
    func enableScoreQstLab() {
        scoreLab.isHidden = false
        scoreLab.isEnabled = true
        numbQstLab.isHidden = false
        numbQstLab.isEnabled = true
    }
    
    func resetSelected() {
        for i in 0...selected.count-1 {
            selected[i] = false
        }
    }
    
    func rightAnsw(_ rightAnsw: [Int]) -> Bool {
        var allRightSel: Bool = true
        var onlyRightSel: Bool = true
        // Controlla se tutte le risposte giuste sono state selezionate
        for i in rightAnsw {
            if(!selected[i]) {
                colorAnsBtn(i, UIColor.systemYellow)
                allRightSel = false
            }
        }
        
        // Controlla se solo le risposte giuste sono segnate
        var isRight = false
        for i in 0...selected.count - 1 {
            isRight = false
            for j in rightAnsw {
                if(i == j) {
                    isRight = true
                    if(selected[i]) {
                        colorAnsBtn(i, UIColor.systemGreen)
                    }
                }
            }
            if(!isRight && selected[i]) {
                colorAnsBtn(i, UIColor.systemRed)
                onlyRightSel = false
            }
        }
        
        return allRightSel && onlyRightSel
    }
    
    func openQstRight(_ answ: String,_ rightAnsw: [String]) -> Bool {
        for strAns in rightAnsw {
            let result: ComparisonResult = answ.compare(strAns, options: NSString.CompareOptions.caseInsensitive)
            if(result == .orderedSame) {
                colorAnsField(UIColor.systemGreen)
                return true
            }
        }
        colorAnsField(UIColor.systemRed)
        return false
    }
    
    func colorAnsField(_ color: UIColor) {
        openAns.backgroundColor = color
    }
    
    func colorAnsBtn(_ index: Int,_ color: UIColor) {
        let defaultColor: UIColor = UIColor.black
        if(index == 0) {
            firstAns.backgroundColor = color
            firstAns.setTitleColor(defaultColor, for: .normal)
        } else if(index == 1) {
            secAns.backgroundColor = color
            secAns.setTitleColor(defaultColor, for: .normal)
        } else if(index == 2) {
            thirdAns.backgroundColor = color
            thirdAns.setTitleColor(defaultColor, for: .normal)
        } else if(index == 3) {
            fourthAns.backgroundColor = color
            fourthAns.setTitleColor(defaultColor, for: .normal)
        }
    }
    
    func setQstAns(_ qstAns: QstAnsw) {
        if(qstAns.type == QstType.SAqst || qstAns.type == QstType.MAqst) {
            showEnabClQstElem()
            qstLab.text = qstAns.qst
            firstAns.setTitle(qstAns.answ[0], for: .normal)
            secAns.setTitle(qstAns.answ[1], for: .normal)
            thirdAns.setTitle(qstAns.answ[2], for: .normal)
            fourthAns.setTitle(qstAns.answ[3], for: .normal)
        } else if(qstAns.type == QstType.OAqst) {
            showEnabOpQstElem()
            openAns.placeholder = wrAnsHereHint
            openAns.text = ""
            qstLab.text = qstAns.qst
        } else {
            print("Malformed question")
        }
    }
    
    func showEnabClQstElem() {
        // Nascondo e disabilito il tasto centrale
        restartBtn.isEnabled = false
        restartBtn.isHidden = true
        
        // Disabilito e nescondo la parte di risposta aperta
        openAns.isHidden = true
        openAns.isEnabled = false
        
        // Abilito la parte di risposta chiusa
        firstAns.isHidden = false
        firstAns.isEnabled = true
        firstAns.backgroundColor = UIColor.white
        secAns.isHidden = false
        secAns.isEnabled = true
        secAns.backgroundColor = UIColor.white
        thirdAns.isHidden = false
        thirdAns.isEnabled = true
        thirdAns.backgroundColor = UIColor.white
        fourthAns.isHidden = false
        fourthAns.isEnabled = true
        fourthAns.backgroundColor = UIColor.white
        
        // Abilito e mostro bottoni controllo e prossimo
        checkBtn.isEnabled = true
        checkBtn.isHidden = false
        nextBtn.isEnabled = true
        nextBtn.isHidden = false
    }
    
    func showEnabOpQstElem() {
        // Nascondo e disabilito il tasto centrale
        restartBtn.isEnabled = false
        restartBtn.isHidden = true
        
        // Disabilito e nescondo la parte di risposta chiusa
        firstAns.isHidden = true
        firstAns.isEnabled = false
        secAns.isHidden = true
        secAns.isEnabled = false
        thirdAns.isHidden = true
        thirdAns.isEnabled = false
        fourthAns.isHidden = true
        fourthAns.isEnabled = false
        
        // Abilito quella di risposta aperta
        openAns.isHidden = false
        openAns.isEnabled = true
        openAns.backgroundColor = UIColor.white
        
        // Abilito e mostro bottoni controllo e prossimo
        checkBtn.isEnabled = true
        checkBtn.isHidden = false
        nextBtn.isEnabled = true
        nextBtn.isHidden = false
    }
    
    func disableAnsCheckBtn() {
        firstAns.isEnabled = false
        secAns.isEnabled = false
        thirdAns.isEnabled = false
        fourthAns.isEnabled = false
        
        openAns.isEnabled = false
        
        checkBtn.isEnabled = false
    }
    
    func selUnsel(_ index: Int) {
        if(!selected[index]) {
            selected[index] = true
            if(index == 0) {
                firstAns.setTitleColor(UIColor.systemOrange, for: .normal)
            } else if(index == 1) {
                secAns.setTitleColor(UIColor.systemOrange, for: .normal)
            } else if(index == 2) {
                thirdAns.setTitleColor(UIColor.systemOrange, for: .normal)
            } else if(index == 3) {
                fourthAns.setTitleColor(UIColor.systemOrange, for: .normal)
            }
        } else {
            selected[index] = false
            if(index == 0) {
                firstAns.setTitleColor(UIColor.systemBlue, for: .normal)
            } else if(index == 1) {
                secAns.setTitleColor(UIColor.systemBlue, for: .normal)
            } else if(index == 2) {
                thirdAns.setTitleColor(UIColor.systemBlue, for: .normal)
            } else if(index == 3) {
                fourthAns.setTitleColor(UIColor.systemBlue, for: .normal)
            }
        }
    }
    
    func unselectAllBtn() {
        firstAns.setTitleColor(UIColor.systemBlue, for: .normal)
        secAns.setTitleColor(UIColor.systemBlue, for: .normal)
        thirdAns.setTitleColor(UIColor.systemBlue, for: .normal)
        fourthAns.setTitleColor(UIColor.systemBlue, for: .normal)
    }
    
    func somethingSelected() -> Bool {
        for i in 0...3 {
            if(selected[i]) {
                return true
            }
        }
        return false
    }
    
    func printQstNum(_ qstNum: Int) {
        numbQstLab.text = String(qstNum) + "/" + String(qst.qstNumber())
    }
    
    func updateScore(_ score: Int) {
        scoreLab.text = scoreTxt + String(score)
    }
    
    func setKeyboardHideTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
}

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height - 170, width: 300, height: 60))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.numberOfLines = 2
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 3.0, delay: 1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
    
}
    
}
