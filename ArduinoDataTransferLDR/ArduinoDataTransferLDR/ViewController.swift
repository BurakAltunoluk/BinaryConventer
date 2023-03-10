//
//  ViewController.swift
//  ArduinoDataTransferLDR
//
//  Created by Burak Altunoluk on 31/12/2022.
//

import UIKit

class ViewController: UIViewController {
    var progressBarLimit = Float(0.0)
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var bitOfNumber: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    var sayBastan = -1
    var eachCharcterInData = Array("")
    var dataMiktari = 0
    var timer = Timer()
    
    @IBOutlet var dataTextView: UITextView!
    @IBOutlet var outputText: UITextView!
    
    @IBOutlet var dataView: UIView!
    @IBOutlet var clockView: UIView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepper.value = 2.0
        dataView.layer.cornerRadius = 5
        dataView.layer.borderWidth = 2
        dataView.layer.borderColor = UIColor.yellow.cgColor
        clockView.layer.cornerRadius = 5
        clockView.layer.borderWidth = 2
        clockView.layer.borderColor = UIColor.yellow.cgColor
        stepper.value = 1.0
    }

    @IBAction func stopButtonPressed(_ sender: Any) {
        self.sayBastan = -1
        self.timer.invalidate()
        dataView.backgroundColor = .black
        clockView.backgroundColor = .black
    }
    
    @IBAction func stepperButtonChanged(_ sender: Any) {
        
        speedLabel.text = String(stepper.value)
        
    }
    @IBAction func sendData(_ sender: Any) {
        timer.invalidate()
        if dataTextView.text != "" {
        binarySender(data: outputText.text!, speed: stepper.value / 10)
        }
        
    }
    
    @IBAction func convertDataToBinaryButtonPressed(_ sender: Any) {
        view.endEditing(true)
        outputText.text = ""
        var allBinaryNumber = ""
        
        let data = [UInt8](Data(dataTextView.text!.utf8))
        
        for i in data {
            
            let asa = binaryConventer(num: Int(i))
            allBinaryNumber += asa
            
        }
        
        outputText.text = allBinaryNumber
        bitOfNumber.text = "\(allBinaryNumber.count) bits"
    }
    
    // data to binary
    func binaryConventer(num: Int) -> String {
        
        var str = String(num, radix: 2)
        for _ in 0..<8 - str.count {
            
        str = "0" + str
            
        }
        
        return str
        
    }

    //----------------
 
    

    
    func binarySender(data:String,speed:Double){
        
       eachCharcterInData = Array(data)
        progressBar.progress = 0.0
       dataMiktari = eachCharcterInData.count
        progressBarLimit =  1 / Float(self.dataMiktari)
       print(" burada \(progressBarLimit)")
        timer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(sendBinaryData), userInfo: nil, repeats: true)
        
  }
    
    @objc func sendBinaryData() {
        dataView.backgroundColor = .black
        clockView.backgroundColor = .black
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            self.sayBastan += 1
            if self.sayBastan != self.dataMiktari {
                if self.eachCharcterInData[self.sayBastan] == "1" {
                    self.dataView.backgroundColor = .yellow
                    self.clockView.backgroundColor = .yellow
            } else {
                
                self.dataView.backgroundColor = .black
                self.clockView.backgroundColor = .yellow
            }
            
            
            } else {
             
                self.sayBastan = -1
                self.timer.invalidate()
      
            }
            self.progressBar.progress += progressBarLimit
        }
  
    }
    
}
