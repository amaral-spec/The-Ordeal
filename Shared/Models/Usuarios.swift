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
final class UsuarioModel: Identifiable {
    var id: CKRecord.ID
    var dataCriacao: Date
    var nome: String
    var email: String
    var isTeacher: Bool = false
    var streak: Int
    var pontos: Int
    var ultimaTarefa: TarefaModel?
    var ultimoDesafio: DesafioModel?
    
    
    // Initializer that creates a user from Apple's sign-in credentials
    init?(credential: ASAuthorizationAppleIDCredential) {
        // The userIdentifier is the unique ID for the user.
        let userIdentifier = credential.user
        self.id = CKRecord.ID(recordName: userIdentifier)
        self.dataCriacao = Date()
        self.nome = credential.fullName?.givenName ?? ""
        self.email = credential.email ?? ""
        self.isTeacher = false
        self.streak = 0
        self.pontos = 0
        self.ultimaTarefa = nil
        self.ultimoDesafio = nil
    }
}


