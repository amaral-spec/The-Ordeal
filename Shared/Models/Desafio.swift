//
//  Desafio.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 27/10/25.
//

import Foundation
import CloudKit


@MainActor
final class DesafioModel: Identifiable {
    var id: CKRecord.ID
    var musica: URL
    var alunos: CKRecord.Reference?
    var grupo: CKRecord.Reference
    
    init(musica: URL, qtdAlunos: Int) {
        self.musica = musica
        self.alunos = []
        self.grupo = nil
    }
}
