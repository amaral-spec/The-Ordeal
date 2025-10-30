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
    var musica: URL
    var alunos: [Usuarios] = []
    
    init(musica: URL, qtdAlunos: Int) {
        self.musica = musica
    }
}
