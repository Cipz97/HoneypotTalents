//
//  ViewController.swift
//  HoneypotTalents
//
//  Created by Matteo Cipone on 29.10.21.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: K.loggedIn, sender: self)
        }
    }


}

