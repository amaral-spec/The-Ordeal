//
//  Atividades.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 27/10/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Tarefas {
    var partitura: Data
    
    @Relationship(inverse: \Usuarios.tarefas)
    var alunos: [Usuarios] = []
    
    init(partitura: Data, qtdAlunos: Int){
        self.partitura = partitura
    }
}
