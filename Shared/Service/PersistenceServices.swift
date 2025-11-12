//
//  CriarGrupoViewModel.swift
//  OsVigaristas
//
//  Created by Júlio Zampietro on 10/11/25.
//

import CloudKit


@MainActor
class PersistenceServices: ObservableObject {
    let db = CKContainer.default().publicCloudDatabase
    
    
// MARK: CRUD: Usuarios
    
    
    
// MARK: CRUD: Grupo
    func createGrupo(_ grupo: GroupModel) async throws {
        let record = CKRecord(recordType: "Grupo", recordID: grupo.id)
        record["name"] = grupo.name as CKRecordValue
        record["members"] = grupo.members as CKRecordValue
        
        do {
            try await db.save(record)
            print("Group created successfully: \(grupo.id)")
        } catch {
            print("Failed to create group: \(error.localizedDescription)")
        }
    }
    
    func deleteGrupo(_ grupo: GroupModel) async throws {
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

    func fetchGrupo(recordID: CKRecord.ID) async throws -> GroupModel {
        let record = try await CKContainer.default().publicCloudDatabase.record(for: recordID)

        let name = record["name"] as? String ?? ""
        let descricao = record["descricao"] as? String ?? ""
        let qtdAlunos = record["qtdAlunos"] as? Int ?? 0
        let refs = record["members"] as? [CKRecord.Reference] ?? []

        let grupo = GroupModel(name: name)
        grupo.id = record.recordID
        grupo.members = refs
        return grupo
    }

    // MARK: Grupo - members
    func addMember(to grupo: GroupModel, usuario: UserModel) async throws {
        let record = try await db.record(for: grupo.id)

        var members = record["members"] as? [CKRecord.Reference] ?? []
        let newRef = CKRecord.Reference(recordID: usuario.id, action: .none)

        // Avoid duplicates
        if !members.contains(where: { $0.recordID == newRef.recordID }) {
            members.append(newRef)
            record["members"] = members
            record["qtdAlunos"] = members.count

            try await db.save(record)
        }
    }

    func removeMember(from grupo: GroupModel, usuario: UserModel) async throws {
        let record = try await db.record(for: grupo.id)

        var members = record["members"] as? [CKRecord.Reference] ?? []
        members.removeAll { $0.recordID == usuario.id }

        record["members"] = members
        record["qtdAlunos"] = members.count

        try await db.save(record)
    }
}


// MARK: CRUD: Desafio







// MARK: CRUD: Tarefa
