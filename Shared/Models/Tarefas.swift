//
//  Atividades.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 27/10/25.
//

import Foundation
import SwiftData

@Model
final class Tarefas {
    var partitura: Data
    
    init(partitura: Data, qtdAlunos: Int){
        self.partitura = partitura
    }
}
