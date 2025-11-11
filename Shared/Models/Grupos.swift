//
//  Grupos.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 28/10/25.
//

import Foundation
import CloudKit


@MainActor
final class GrupoModel: Identifiable {
    var id: CKRecord.ID
    var nome: String
    var qtdAlunos: Int
    var membros: [CKRecord.Reference]
    
    init(nome: String, descricao: String, qtdAlunos: Int) {
        self.id = CKRecord.ID(recordName: UUID().uuidString)
        self.nome = nome
        self.qtdAlunos = qtdAlunos
        self.membros = []
    }
}
