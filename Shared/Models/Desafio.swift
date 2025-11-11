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
    var audioGeral: URL?
    var grupo: CKRecord.Reference?
    var titulo: String
    var descricao: String
    var tipoDesafio: Int // ver se vale a pena colocar nome
    var recompensa: Int
    var inicio: Date
    var fim: Date
    
    
    init(tipoDesafio: Int, titulo: String, descricao: String, grupo: CKRecord.Reference, recompensa: Int, inicio: Date, fim: Date) {
        self.id = CKRecord.ID(recordName: UUID().uuidString)
        self.audioAlunos = []
        self.audioGeral = nil
        self.grupo = grupo
        self.titulo = titulo
        self.descricao = descricao
        self.tipoDesafio = tipoDesafio
        self.recompensa = recompensa
        self.inicio = inicio
        self.fim = fim
    }
}
