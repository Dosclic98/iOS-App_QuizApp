//
//  QuestionsViewController.swift
//  QuizApp
//
//  Created by Davide Savarro on 19/02/2020.
//  Copyright © 2020 Davide Savarro. All rights reserved.
//

import Foundation
import UIKit

var qst = Questions()
var currQstIndx = 0
var currScore = 0

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
    
    @IBOutlet weak var checkBtn: RoundButton!
    @IBOutlet weak var nextBtn: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //presentingViewController?.dismiss(animated: true, completion: nil)
        qst.qstInitializer()
        printQstNum(currQstIndx + 1)
        updateScore(currScore)
        setQstAns(qst.getQst(currQstIndx))
    }
    
    @IBAction func firstAnsSel(_ sender: Any) {
        selUnsel(0)
    }
    
    @IBAction func secAnsSel(_ sender: Any) {
        selUnsel(1)
    }
    
    @IBAction func thirdAnsSel(_ sender: Any) {
        selUnsel(2)
    }
    
    @IBAction func fourthAnsSel(_ sender: Any) {
        selUnsel(3)
    }
    
    @IBAction func checkAct(_ sender: Any) {
        let qstAns = qst.getQst(currQstIndx)
        if(qstAns.type == QstType.SAqst || qstAns.type == QstType.MAqst) {
            if(somethingSelected()) {
                if(rightAnsw(qstAns.correct)) {
                    currScore += 1
                }
                updateScore(currScore);
                disableAnsCheckBtn()
            } else {
                showToast(message: "Seleziona una risposta prima di verificare", font: UIFont.systemFont(ofSize: 20))
            }
        } else if(qstAns.type == QstType.OAqst) {
            let answer: String? = openAns.text
            if(answer == "") {
                showToast(message: "Inserisci una risposta prima di controllarla", font: UIFont.systemFont(ofSize: 20))
            } else {
                if(openQstRight(answer!, qstAns.answ)) {
                    currScore += 1
                }
                updateScore(currScore);
                disableAnsCheckBtn()
            }
            
        } else {
            print("Malformed question")
        }
    }
    
    @IBAction func nextAct(_ sender: Any) {
        
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
            if(answ == strAns) {
                return true
            }
        }
        return false
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
            qstLab.text = qstAns.qst
        } else {
            print("Malformed question")
        }
    }
    
    func showEnabClQstElem() {
        // Disabilito e nescondo la parte di risposta aperta
        openAns.isHidden = true
        openAns.isEnabled = false
        
        // Abilito la parte di risposta chiusa
        firstAns.isHidden = false
        firstAns.isEnabled = true
        secAns.isHidden = false
        secAns.isEnabled = true
        thirdAns.isHidden = false
        thirdAns.isEnabled = true
        fourthAns.isHidden = false
        fourthAns.isEnabled = true
    }
    
    func showEnabOpQstElem() {
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
        scoreLab.text = "Score: " + String(score)
    }

}

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height - 150, width: 300, height: 60))
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
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
