//
//  Grupos.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 28/10/25.
//

import Foundation
import SwiftData

@Model
final class Grupos {
    var id: String = UUID().uuidString
    var nome: String?
    var descricao: String?
    var qtdAlunos: Int?
    
    @Relationship(deleteRule: .nullify)
    var membros: [Usuarios]?
    
    @Relationship(deleteRule: .cascade, inverse: \Tarefas.grupo)
    var tarefas: [Tarefas]?
    
    @Relationship(deleteRule: .cascade, inverse: \Desafio.grupo)
    var desafios: [Desafio]?
    
    init(nome: String, descricao: String, qtdAlunos: Int) {
        self.nome = nome
        self.descricao = descricao
        self.qtdAlunos = qtdAlunos
        self.membros = []
    }
}
