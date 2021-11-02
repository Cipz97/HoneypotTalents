//
//  ChatAppUser.swift
//  HoneypotTalents
//
//  Created by Matteo Cipone on 02.11.21.
//

import Foundation

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAdrdress: String
    var safeEmail: String {
        var safeEmail = emailAdrdress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    //TODO: profilePicture
}
