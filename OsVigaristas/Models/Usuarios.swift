//
//  Usuarios.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 29/10/25.
//

import SwiftData
import Foundation

@Model
final class Usuarios {
    var nome: String?
    var email: String?
    var senha: String?
    var isProfessor: Bool = false
    var desafios: [Desafio]? = []
    var tarefas: [Tarefas]? = []
    
    init(nome: String, email: String, senha: String, isProfessor: Bool) {
        self.nome = nome
        self.email = email
        self.senha = senha
        self.isProfessor = isProfessor
    }
    
}
