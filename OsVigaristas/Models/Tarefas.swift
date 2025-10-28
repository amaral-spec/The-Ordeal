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
    
    @Relationship(inverse: \Alunos.atividades)
    var alunos: [Alunos] = []
    
    init(partitura: Data, qtdAlunos: Int){
        self.partitura = partitura
    }
}
