//
//  Usuarios.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 29/10/25.
//

import SwiftData
import Foundation
import CloudKit
import AuthenticationServices

@Model
final class Usuarios: Identifiable {
    // MARK: Variables
    //@Attribute(.unique)
    var id: String = UUID().uuidString
    var nome: String?
    var email: String?
    var isProfessor: Bool = false
    var hasCompletedOnboarding: Bool = false
    
    
    // MARK: Relationships
    @Relationship(deleteRule: .nullify)
    var tarefas: [Tarefas]?
    
    @Relationship(deleteRule: .nullify)
    var grupos: [Grupos]?
    
    @Relationship(deleteRule: .nullify)
    var desafios: [Desafio]?
    
    
    // MARK: Initializers
    // Initializer for SwiftData
    init(id: String, nome: String? = nil, email: String? = nil, isProfessor: Bool = false) {
        self.id = id
        self.nome = nome
        self.email = email
        self.isProfessor = isProfessor
    }
    
    // Convenience initializer that creates a user from Apple's sign-in credentials
    convenience init?(credential: ASAuthorizationAppleIDCredential) {
        // The userIdentifier is the unique ID for the user.
        let userIdentifier = credential.user
        let name = credential.fullName?.givenName
        let email = credential.email
        self.init(id: userIdentifier, nome: name, email: email)
    }
    
    
}
