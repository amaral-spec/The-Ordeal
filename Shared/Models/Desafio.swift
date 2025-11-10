//
//  Desafio.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 27/10/25.
//

import Foundation
import SwiftData

@Model
final class Desafio {
    var musica: URL?
    
    @Relationship(deleteRule: .nullify)
    var alunos: [Usuarios]?
    
    @Relationship(deleteRule: .nullify)
    var grupo: Grupos?
    
    init(musica: URL, qtdAlunos: Int) {
        self.musica = musica
        self.alunos = []
        self.grupo = nil
    }
}
