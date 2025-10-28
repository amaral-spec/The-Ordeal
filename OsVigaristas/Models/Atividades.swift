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
final class Atividades {
    var partitura: Image
    
    @Relationship(inverse: \Alunos.atividades)
    var alunos: [Alunos] = []
    
    init(partitura: Image, qtdAlunos: Int){
        self.partitura = partitura
    }
}
