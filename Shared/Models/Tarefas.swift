//
//  Atividades.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 27/10/25.
//

import Foundation
import CloudKit


@MainActor
final class TarefasModel: Identifiable {
    var id: CKRecord.ID
    var partitura: Data
    var aluno: CKRecord.Reference?
    var grupo: CKRecord.Reference
    
    init(partitura: Data, qtdAlunos: Int){
        self.partitura = partitura
        self.aluno = nil
    }
}
