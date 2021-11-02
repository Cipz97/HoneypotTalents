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
    
    func addUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue(["first_name": user.firstName, "last_name":user.lastName])
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
}
