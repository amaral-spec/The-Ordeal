//
//  ModelsAlunosEGrupos.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 11/11/25.
//

import Foundation

struct Aluno: Identifiable, Codable {
    let id: Int
    let nome: String
    let foto: String
}

struct Grupo: Identifiable, Codable {
    let id: Int
    let nome: String
    let foto: String
    let quantidadeAlunos: Int
}
