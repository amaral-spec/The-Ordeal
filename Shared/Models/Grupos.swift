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
    var membros: [CKRecord.Reference]
    
    init(nome: String) {
        self.id = CKRecord.ID(recordName: UUID().uuidString)
        self.nome = nome
        self.membros = []
    }
}
