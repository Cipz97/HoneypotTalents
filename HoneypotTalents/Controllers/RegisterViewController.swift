//
//  RegisterViewController.swift
//  HoneypotTalents
//
//  Created by Matteo Cipone on 29.10.21.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(changeProfilePicture))
        imageView.addGestureRecognizer(gesture)
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text, let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
            DatabaseManager.shared.validateNewUser(with: email) { emailExists in
                guard !emailExists else {
                    self.passwordTextfield.placeholder = "Error user already exists"
                    return
                }
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        print(error)
                        self.passwordTextfield.placeholder = "\(error.localizedDescription)"
                    } else {
                        DatabaseManager.shared.addUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAdrdress: email))
                        self.performSegue(withIdentifier: K.segueToSignIn, sender: self)
                    }
                }
            }
        }
    }
    
    @objc func changeProfilePicture() {
        presentPhotoActionSheet()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    // saves image value to view & TODO: database safe
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] {
            self.imageView.image = image as? UIImage
        }
        
        
    }
    // Asks user how they want to choose their profile picture
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a Picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take picture", style: .default, handler: { _ in
            self.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose picture", style: .default, handler: { _ in
            self.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    // presents Camera to take picture for profile Pic
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    // lets you choose from photolibrary
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

}
