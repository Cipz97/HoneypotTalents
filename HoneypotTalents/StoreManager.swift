//
//  StoreManager.swift
//  HoneypotTalents
//
//  Created by Matteo Cipone on 16.11.21.
//

import Foundation
import FirebaseStorage

class StorageManager {
    
    static let sharedStorage = StorageManager()
    private let storage = Storage.storage().reference()
    
    func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        storage.child("images/\(fileName)").putData(data, metadata: nil) { metadata, error in
            guard error == nil else {
                return
            }
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    return
                }
                let urlString = url.absoluteString
                completion(.success(urlString))
            }
        }
    }
    func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                return
            }
            completion(.success(url))
        }
    }
    
}
