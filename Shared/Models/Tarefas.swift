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
    var aluno: CKRecord.Reference
    var titulo: String
    var descricao: String
    var recompensa: Int
    var inicio: Date
    var fim: Date
    
    
    init(titulo: String, descricao: String, aluno: CKRecord.Reference, inicio: Date, fim: Date){
        self.id = CKRecord.ID(recordName: UUID().uuidString)
        self.audioAluno = []
        self.aluno = aluno
        self.titulo = titulo
        self.descricao = descricao
        self.recompensa = 0
        self.inicio = inicio
        self.fim = fim
    }
}
