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
    func deleteUser(_ usuario: UserModel) async throws {
        try await db.deleteRecord(withID: usuario.id)
        print("User deleted successfully: \(usuario.id.recordName)")
    }
    
    func fetchUser(recordID: CKRecord.ID) async throws -> UserModel {
        let record = try await db.record(for: recordID)

        let name = record["name"] as? String ?? ""
        let email = record["email"] as? String ?? ""
        let isTeacher = record["isTeacher"] as? Bool ?? false
        let streak = record["streak"] as? Int ?? 0
        let points = record["points"] as? Int ?? 0
        let lastTask: TaskModel?
        let lastChallenge: ChallengeModel?
        
        //usuario.lastChallenge = try await fetchLatestChallenge(for: recordID, in: db)
        
        let usuario = UserModel(from: record)
        usuario.id = record.recordID
        usuario.email = email
        usuario.isTeacher = isTeacher
        usuario.streak = streak
        usuario.points = points
        usuario.lastTask = try await fetchLatestTask(for: recordID, in: db)
        usuario.lastChallenge = nil // implementar funcao de encontrar ultimo challenge
        return usuario
    }
    
    
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

    func editGrupo(recordID: CKRecord.ID, newName: String, newDescricao: String, newQtdAlunos: Int, newMembers: [CKRecord.Reference]) async throws {
        // Note to development team: when implementing this function, you first need
        // to call fetchGrupo to populate the fields, and then pass this function
        
        let record = try await db.record(for: recordID)
        
        record["name"] = newName as CKRecordValue
        record["descricao"] = newDescricao as CKRecordValue
        record["qtdAlunos"] = newQtdAlunos as CKRecordValue
        record["members"] = newMembers as CKRecordValue
        
        do {
            try await db.save(record)
            print("Grupo editado com sucesso")
        } catch {
            print("Falha ao editar grupo")
            throw error
        }
    }
    
    func fetchGrupo(recordID: CKRecord.ID) async throws -> GroupModel {
        let record = try await db.record(for: recordID)

        let name = record["name"] as? String ?? ""
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



    func fetchLatestTask(for userRecordID: CKRecord.ID, in db: CKDatabase) async throws -> TaskModel? {
        let predicate = NSPredicate(format: "student == %@", CKRecord.Reference(recordID: userRecordID, action: .none))
        let taskQuery = CKQuery(recordType: "Task", predicate: predicate)
        
        // Performs queries
        let (resultsTask, _) = try await db.records(matching: taskQuery)
        
        // Extract CKRecords from the Result dictionary
        let validRecords: [CKRecord] = resultsTask.compactMap { (_, result) in
            try? result.get()  // Converts Result<CKRecord, Error> into CKRecord or nil
        }

        // Filter out records that don't have an endDate or are in the future
        let pastTasks = validRecords.compactMap { record -> (CKRecord, Date)? in
            guard let endDate = record["endDate"] as? Date,
                  endDate < Date() else {
                return nil
            }
            return (record, endDate)
        }

        // Sort descending by endDate
        let sortedTasks = pastTasks.sorted { $0.1 > $1.1 }

        // Pick the first (most recent) one
        guard let (latestRecord, _) = sortedTasks.first else {
            print("No past tasks found")
            return nil
        }
   
        return await TaskModel(
            title: latestRecord["title"] as? String ?? "",
            description: latestRecord["description"] as? String ?? "",
            student: latestRecord["student"] as! CKRecord.Reference,
            startDate: latestRecord["startDate"] as? Date ?? Date(),
            endDate: latestRecord["endDate"] as? Date ?? Date()
        )
    }



