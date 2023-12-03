//
//  ViewController.swift
//  UserDefaults
//
//  Created by Zehra Nur Açık on 11.10.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var notTextField: UITextField!
    
    
    @IBOutlet weak var zamanTextField: UITextField!
    
    @IBOutlet weak var notLabel: UILabel!
    
    @IBOutlet weak var zamanLabel: UILabel!
    
    let kaydedilenNot = UserDefaults.standard.object(forKey: "not")
    let kaydedilenZaman = UserDefaults.standard.object(forKey: "zaman")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gelenNot = kaydedilenNot as? String{
            notLabel.text = "İş: \(gelenNot)"
        }
        
        if let gelenZaman = kaydedilenZaman as? String{
            zamanLabel.text = "Zaman: \(gelenZaman)"
        }
    }

    @IBAction func kaydetTiklandi(_ sender: Any) {
        
        UserDefaults.standard.set(notTextField.text!, forKey: "not")
        UserDefaults.standard.set(zamanTextField.text!, forKey: "zaman")
        
        notLabel.text = "İş: \(notTextField.text!)"
        zamanLabel.text = "Zaman: \(zamanTextField.text!)"
    }
    
    @IBAction func silTiklandi(_ sender: Any) {
        
        if (kaydedilenNot as? String) != nil{
            UserDefaults.standard.removeObject(forKey: "not")
            notLabel.text = "İş:"
        }
        
        if (kaydedilenZaman as? String) != nil{
            UserDefaults.standard.removeObject(forKey: "zaman")
            zamanLabel.text = "Zaman:"
        }
    }
    
}

