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
        qst.qstInitializer()
        printQstNum(currQstIndx + 1)
        printScore(currScore)
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
        if(qstAns.type == QstType.SAqst) {
            
        } else if(qstAns.type == QstType.MAqst) {
            
        } else if(qstAns.type == QstType.OAqst) {

        } else {
            print("Malformed question")
        }
    }
    
    @IBAction func nextAct(_ sender: Any) {
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
    
    func printQstNum(_ qstNum: Int) {
        numbQstLab.text = String(qstNum) + "/" + String(qst.qstNumber())
    }
    
    func printScore(_ score: Int) {
        scoreLab.text = "Score: " + String(score)
    }

}

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
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
