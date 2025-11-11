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
    var audioAlunos: [URL]
    var audioGeral: URL
    var alunos: CKRecord.Reference?
    var grupo: CKRecord.Reference
    var titulo: String
    var descricao: String
    var tipoDesafio: Int // ver se vale a pena colocar nome
    var recompensa: Int
    var inicio: Date
    var fim: Date
    
    
    init(musica: URL, qtdAlunos: Int) {
        self.alunos = []
        self.grupo = nil
    }
}
