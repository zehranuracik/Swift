//
//  SignUpViewController.swift
//  MyFirstApp
//
//  Created by Zehra Nur Açık on 12.10.2023.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordAgainText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text == ""{
            alertMessageFunction(
                alertTitle: "Error Message!",
                alert: "Email can't be left blank!")
        }
        else if passwordText.text == "" || passwordAgainText.text == ""{
            alertMessageFunction(
                alertTitle: "Error Message!",
                alert: "Password can't be left blank!")
        }
        else if passwordText.text != passwordAgainText.text{
            alertMessageFunction(
                alertTitle: "Error Message!",
                alert: "Passwords don't match!")
        }
        else{
            alertMessageFunction(
                alertTitle: "Succeed!",
                alert: "You have successfully registered.")
            
            UserDefaults.standard.set(emailText.text!, forKey: "email")
            UserDefaults.standard.set(passwordText.text!, forKey: "password")
        }
        
    }
    
    
    func alertMessageFunction(alertTitle : String, alert : String){
        let alertMessage = UIAlertController(
            title: alertTitle,
            message: alert,
            preferredStyle: .alert
        )
        
        let okButton = UIAlertAction(
            title: "OK",
            style: .default
        ){
            (UIAlertAction) in
            print("Record Created")
        }
        
        alertMessage.addAction(okButton)
        
        self.present(
            alertMessage,
            animated: true,
            completion: nil)
    }


}
