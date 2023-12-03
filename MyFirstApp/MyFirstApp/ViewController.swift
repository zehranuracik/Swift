//
//  ViewController.swift
//  MyFirstApp
//
//  Created by Zehra Nur Açık on 12.10.2023.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func signInClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSignInVC", sender: nil)
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSignUpVC", sender: nil)
    }
}

