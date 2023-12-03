//
//  SignInViewController.swift
//  MyFirstApp
//
//  Created by Zehra Nur Açık on 12.10.2023.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    let userEmail = UserDefaults.standard.object(forKey: "email")
    let userPassword = UserDefaults.standard.object(forKey: "password")
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text == (userEmail as! String){
            if passwordText.text == (userPassword as! String){
                performSegue(withIdentifier: "toSucceedVC", sender: nil)
            }
            else if passwordText.text == ""{
                alertMessageFunction(
                alertTitle: "Error Message!",
                alert: "Enter your password!")
            }
            else{
                alertMessageFunction(
                alertTitle: "Error Message!",
                alert: "Password is incorrect!")
            }
        }
        else if emailText.text == "" {
            alertMessageFunction(
            alertTitle: "Error Message!",
            alert: "Enter your Email!")
        }
        else{
            if passwordText.text == (userPassword as! String){
                alertMessageFunction(
                alertTitle: "Error Message!",
                alert: "Email is incorrect!")
            }
            else{
                alertMessageFunction(
                alertTitle: "Error Message!",
                alert: "Email and password are incorrect!")
            }
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
