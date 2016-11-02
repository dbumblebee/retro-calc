//
//  ViewController.swift
//  retro-calc
//
//  Created by Brian Bresen on 11/2/16.
//  Copyright © 2016 BeeHive Productions. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Equals = "="
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    var runningNumber = ""
    var counterStr = "0.0"
    var currentOperation: Operation = Operation.Empty
    var priorInput = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
     
        do {
           try btnSound = AVAudioPlayer(contentsOf: soundUrl as URL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    @IBAction func numberPressed(btn: UIButton!) {
        playSound()
        
        runningNumber += "\(btn.tag)"
        outputLbl.text = runningNumber
    }
    
    @IBAction func onDividePressed(_ sender: AnyObject) {
        processOperation(op: Operation.Divide)
    }
    
    @IBAction func onMultiplyPressed(_ sender: AnyObject) {
        processOperation(op: Operation.Multiply)
    }
    
    @IBAction func onSubtractPressed(_ sender: AnyObject) {
        processOperation(op: Operation.Subtract)
    }
    
    @IBAction func onAddPressed(_ sender: AnyObject) {
        processOperation(op: Operation.Add)
    }
    
    @IBAction func onEqualPressed(_ sender: AnyObject) {
        processOperation(op: Operation.Equals)
    }
    
    func processOperation(op: Operation) {
        playSound()
        //Check if numbers were typed
        if runningNumber != "" {
           if currentOperation != Operation.Empty {
                //Run some Math, priorInput saves number for repeat on equals
                doOperation(myNum: runningNumber)
                priorInput = runningNumber
            } else {
                //This is the first time an operator has been pressed
                counterStr = runningNumber
            }
        } else {
            //if user hits equals without typing numbers
            //repeat prior operation with prior runningNumber
            if op == Operation.Equals && priorInput != "" {
                doOperation(myNum: priorInput)
            }
        }
        outputLbl.text = counterStr
        
        runningNumber = ""
        if op != Operation.Equals {
            currentOperation = op
        }
    }
    
    //do the currentOperation on counter with a passed variable
    func doOperation(myNum: String) {
        if currentOperation == Operation.Multiply {
            counterStr = "\(Double(counterStr)! * Double(myNum)!)"
        } else if currentOperation == Operation.Divide {
            counterStr = "\(Double(counterStr)! / Double(myNum)!)"
        } else if currentOperation == Operation.Subtract {
            counterStr = "\(Double(counterStr)! - Double(myNum)!)"
        } else if currentOperation == Operation.Add {
            counterStr = "\(Double(counterStr)! + Double(myNum)!)"
        }
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
    
        btnSound.play()
    }
}

