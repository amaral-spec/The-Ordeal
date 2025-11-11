//
//  CriarGrupoViewModel.swift
//  OsVigaristas
//
//  Created by Júlio Zampietro on 10/11/25.
//

import CloudKit


@MainActor
class GrupoViewModel: ObservableObject {
    
    
    // MARK: Create, delete, fetch
    func createGrupo(_ grupo: GrupoModel) async throws {
        let record = CKRecord(recordType: "Grupo", recordID: grupo.id)
        record["nome"] = grupo.nome as CKRecordValue
        record["membros"] = grupo.membros as CKRecordValue
        
        let db = CKContainer.default().publicCloudDatabase
        
        do {
            try await db.save(record)
            print("Group created successfully: \(grupo.id)")
        } catch {
            print("Failed to create group: \(error.localizedDescription)")
        }
    }
    
    func deleteGrupo(_ grupo: GrupoModel) async throws {
        let db = CKContainer.default().publicCloudDatabase

        // Creates references and predicates for the group
        let gruporef = CKRecord.Reference(recordID: grupo.id, action: .none)
        let predicate = NSPredicate(format: "grupo == %@", gruporef)
        
        // Creates queries for tarefa and desafio
        let queryTarefa = CKQuery(recordType: "Tarefa", predicate: predicate)
        let queryDesafio = CKQuery(recordType: "Desafio", predicate: predicate)
        
        // Performs queries
        let (resultsTarefa, _) = try await db.records(matching: queryTarefa)
        let (resultsDesafio, _) = try await db.records(matching: queryDesafio)
        
        // Deletes related tarefas
        for (_, result) in resultsTarefa {
            if case .success(let record) = result {
                try await db.deleteRecord(withID: record.recordID)
                print("Deleted tarefa: \(record.recordID.recordName)")
            }
        }
        
        // Deletes related desafios
        for (_, result) in resultsDesafio {
            if case .success(let record) = result {
                try await db.deleteRecord(withID: record.recordID)
                print("Deleted desafio: \(record.recordID.recordName)")
            }
        }
        
        // Deletes group
        try await db.deleteRecord(withID: grupo.id)
        print("Group deleted successfully: \(grupo.id.recordName)")
    }

    func fetchGrupo(recordID: CKRecord.ID) async throws -> GrupoModel {
        let record = try await CKContainer.default().publicCloudDatabase.record(for: recordID)

        let nome = record["nome"] as? String ?? ""
        let descricao = record["descricao"] as? String ?? ""
        let qtdAlunos = record["qtdAlunos"] as? Int ?? 0
        let refs = record["membros"] as? [CKRecord.Reference] ?? []

        let grupo = GrupoModel(nome: nome)
        grupo.id = record.recordID
        grupo.membros = refs
        return grupo
    }

    // MARK: Add member, remove member
    func addMember(to grupo: GrupoModel, usuario: UsuarioModel) async throws {
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

    func removeMember(from grupo: GrupoModel, usuario: UsuarioModel) async throws {
        let db = CKContainer.default().publicCloudDatabase
        let record = try await db.record(for: grupo.id)

        var members = record["membros"] as? [CKRecord.Reference] ?? []
        members.removeAll { $0.recordID == usuario.id }

        record["membros"] = members
        record["qtdAlunos"] = members.count

        try await db.save(record)
    }
}
