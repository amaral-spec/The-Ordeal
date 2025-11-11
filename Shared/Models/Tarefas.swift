//
//  Atividades.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 27/10/25.
//

import Foundation
import CloudKit


@MainActor
final class TarefaModel: Identifiable {
    var id: CKRecord.ID
    var audioAluno: [URL]
    var aluno: CKRecord.Reference?
    var grupo: CKRecord.Reference
    var titulo: String
    var descricao: String
    var recompensa: Int
    var inicio: Date
    var termino: Date
    
    
    init(partitura: Data, qtdAlunos: Int){
        self.partitura = partitura
        self.aluno = nil
    }
}
