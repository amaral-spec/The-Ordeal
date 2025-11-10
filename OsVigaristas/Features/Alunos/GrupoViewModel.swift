//
//  CriarGrupoViewModel.swift
//  OsVigaristas
//
//  Created by Júlio Zampietro on 10/11/25.
//

import CloudKit


@MainActor
class GrupoViewModel: ObservableObject {
    
    func createGrupo(_ grupo: GruposModel) async throws {
        let record = CKRecord(recordType: "Grupos", recordID: grupo.id)
        record["nome"] = grupo.nome as CKRecordValue
        record["descricao"] = grupo.descricao as CKRecordValue
        record["qtdAlunos"] = grupo.qtdAlunos as CKRecordValue
        record["membros"] = grupo.membros as CKRecordValue
        
        try await CKContainer.default().publicCloudDatabase.save(record)
    }

    func fetchGrupo(recordID: CKRecord.ID) async throws -> GruposModel {
        let record = try await CKContainer.default().publicCloudDatabase.record(for: recordID)

        let nome = record["nome"] as? String ?? ""
        let descricao = record["descricao"] as? String ?? ""
        let qtdAlunos = record["qtdAlunos"] as? Int ?? 0
        let refs = record["membros"] as? [CKRecord.Reference] ?? []

        let grupo = GruposModel(nome: nome, descricao: descricao, qtdAlunos: qtdAlunos)
        grupo.id = record.recordID
        grupo.membros = refs
        return grupo
    }

    func addMember(to grupo: GruposModel, usuario: UsuariosModel) async throws {
        let db = CKContainer.default().publicCloudDatabase
        let record = try await db.record(for: grupo.id)

        var members = record["membros"] as? [CKRecord.Reference] ?? []
        let newRef = CKRecord.Reference(recordID: usuario.id, action: .none)

        // Avoid duplicates
        if !members.contains(where: { $0.recordID == newRef.recordID }) {
            members.append(newRef)
            record["membros"] = members
            record["qtdAlunos"] = members.count

            try await db.save(record)
        }
    }

    func removeMember(from grupo: GruposModel, usuario: UsuariosModel) async throws {
        let db = CKContainer.default().publicCloudDatabase
        let record = try await db.record(for: grupo.id)

        var members = record["membros"] as? [CKRecord.Reference] ?? []
        members.removeAll { $0.recordID == usuario.id }

        record["membros"] = members
        record["qtdAlunos"] = members.count

        try await db.save(record)
    }

}
