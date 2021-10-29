//
//  RegisterViewController.swift
//  HoneypotTalents
//
//  Created by Matteo Cipone on 29.10.21.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print(error)
                    self.passwordTextfield.placeholder = "\(error.localizedDescription)"
                } else {
                    self.performSegue(withIdentifier: K.segueToSignIn, sender: self)
                }
            }
        }
    }
    

}
