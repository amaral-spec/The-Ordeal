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
final class UsuariosModel: Identifiable {
    var id: CKRecord.ID
    var nome: String
    var email: String
    var isProfessor: Bool = false
    var hasCompletedOnboarding: Bool = false
    
    // Initializer that creates a user from Apple's sign-in credentials
    init?(credential: ASAuthorizationAppleIDCredential) {
        // The userIdentifier is the unique ID for the user.
        let userIdentifier = credential.user
        self.id = CKRecord.ID(recordName: userIdentifier)
        self.nome = credential.fullName?.givenName ?? ""
        self.email = credential.email ?? ""
    }
}


