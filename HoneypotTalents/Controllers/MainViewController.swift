//
//  MainViewController.swift
//  HoneypotTalents
//
//  Created by Matteo Cipone on 29.10.21.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    //logs out user
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    //On click user gets sent to profile page
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.goToProfile, sender: self)
    }
    
    //TableView amount of conversations
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //cell for TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        cell.textLabel?.text = "Test"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    //selecting TableView row shows you detailed chat with contact
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController()
        vc.title = "Jenny"
        navigationController?.pushViewController(vc, animated: true)
    }
}
