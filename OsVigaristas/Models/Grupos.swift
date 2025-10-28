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
    var nome: String
    var descricao: String
    var qtdAlunos: Int
    
    init(nome: String, descricao: String, qtdAlunos: Int) {
        self.nome = nome
        self.descricao = descricao
        self.qtdAlunos = qtdAlunos
    }
}
