//
//  DatabaseManager.swift
//  HoneypotTalents
//
//  Created by Matteo Cipone on 01.11.21.
//

import Foundation
import Firebase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    let database = Database.database(url: "https://honeypotmobile-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    func addUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue(["first_name": user.firstName, "last_name":user.lastName]) { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value) { snapshot in
                if var userCollection = snapshot.value as? [[String: String]] {
                    let newElement = ["name": user.firstName + " " + user.lastName, "email": user.safeEmail]
                    userCollection.append(newElement)
                    self.database.child("users").setValue(userCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    }
                } else {
                    let newCollection: [[String: String]] = [["name": user.firstName + " " + user.lastName, "email": user.safeEmail]]
                    self.database.child("users").setValue(newCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    }
                }
            }
        }
    }
    static func safeEmail(with emailAdrdress: String) -> String {
        var safeEmail = emailAdrdress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    func validateNewUser(with email: String, completion: @escaping ((Bool) -> Void)) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            if let foundEmail = snapshot.value as? String {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                return
            }
            completion(.success(value))
        }
    }
}
