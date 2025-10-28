//
//  Alunos.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 27/10/25.
//

import Foundation
import SwiftData

@Model
final class Alunos {
    var nome: String
    var atividades: [Atividades] = []
    
    init(nome: String) {
        self.nome = nome
    }
}
