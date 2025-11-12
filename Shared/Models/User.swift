//
//  Usuarios.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 29/10/25.
//

import Foundation
import CloudKit
import AuthenticationServices


@MainActor
final class UserModel: Identifiable {
    var id: CKRecord.ID
    var creationDate: Date
    var name: String
    var email: String
    var isTeacher: Bool = false
    var streak: Int
    var points: Int
    var lastTask: TaskModel?
    var lastChallenge: ChallengeModel?
    
    
    // Initializer that creates a user from Apple's sign-in credentials
    init?(credential: ASAuthorizationAppleIDCredential) {
        // The userIdentifier is the unique ID for the user.
        let userIdentifier = credential.user
        self.id = CKRecord.ID(recordName: userIdentifier)
        self.creationDate = Date()
        self.name = credential.fullName?.givenName ?? ""
        self.email = credential.email ?? ""
        self.isTeacher = false
        self.streak = 0
        self.points = 0
        self.lastTask = nil
        self.lastChallenge = nil
    }
    
    init(id: CKRecord.ID) {
        self.id = id
    }
    
}


