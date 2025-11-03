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
    var isProfessor: Bool = false
    var nome: String
    var desafios: [Desafio] = []
    
    @Relationship
    var tarefas: [Tarefas] = []
    
    init(isProfessor: Bool, nome: String, desafios: [Desafio]) {
        self.isProfessor = isProfessor
        self.nome = nome
        self.desafios = desafios
    }
    
}
