//
//  Item.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 27/10/25.
//

import Foundation
import SwiftData

@Model
final class Professor {
    var nome: String
    var desafios: [Desafio] = []
    var atividades: [Atividades] = []
    
    
    init(nome: String) {
        self.nome = nome
        self.desafios = desafios
    }
}
