//
//  ProfileViewController.swift
//  HoneypotTalents
//
//  Created by Matteo Cipone on 29.10.21.
//

import UIKit
import Firebase
import SwiftUI

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var lastnameTextfield: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        if let profilePicture = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            changeRequest?.photoURL = profilePicture
            changeRequest?.commitChanges { error in
                if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                    self.imageView.image = selectedImage
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Select a picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take a picture", style: .default, handler: { _ in
            self.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose picture", style: .default, handler: { _ in
            self.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func getProfilePicture() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(with: email)
        let fileName = safeEmail + "_profile_picture.png"
        let path = "images/" + fileName
        StorageManager.sharedStorage.downloadURL(for: path) { result in
            switch result {
                case .success(let url):
                    self.downloadImage(url: url)
                case .failure(let error):
                    print(error)
            }
        }
    }
    func downloadImage(url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.imageView.image = image
            }
            
        }.resume()
    }
    
}
