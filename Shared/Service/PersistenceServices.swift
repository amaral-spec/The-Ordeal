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
    func fetchUser(recordID: CKRecord.ID) async throws -> UserModel {
        let record = try await db.record(for: recordID)
        
        let name = record["name"] as? String ?? ""
        let email = record["email"] as? String ?? ""
        let isTeacher = record["isTeacher"] as? Bool ?? false
        let streak = record["streak"] as? Int ?? 0
        let points = record["points"] as? Int ?? 0
        let lastTask: TaskModel?
        let lastChallenge: ChallengeModel?
        
        let usuario = UserModel(from: record)
        usuario.id = record.recordID
        usuario.email = email
        usuario.isTeacher = isTeacher
        usuario.streak = streak
        usuario.points = points
        usuario.lastTask = try await fetchLatestTask(for: recordID, in: db)
        usuario.lastChallenge = try await fetchLatestChallenge(for: recordID, in: db)
        return usuario
    }
    
    func editUser(recordID: CKRecord.ID, newName: String, newEmail: String, isTeacher: Bool) async throws {
        let record = try await db.record(for: recordID)
        
        record["name"] = newName as CKRecordValue
        record["email"] = newEmail as CKRecordValue
        record["isTeacher"] = isTeacher as CKRecordValue
        
        do {
            try await db.save(record)
            print("User edited successfully")
        } catch {
            print("Failed to update user")
            throw error
        }
    }
    
    func deleteUser(_ usuario: UserModel) async throws {
        try await db.deleteRecord(withID: usuario.id)
        print("User deleted successfully: \(usuario.id.recordName)")
    }
    
    // MARK: CRUD: Grupo
    func createGroup(_ grupo: GroupModel) async throws {
        guard let currentUser = AuthService.shared.currentUser else {
            throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No user loggoed in"])
        }
        
        let userRef = CKRecord.Reference(recordID: currentUser.id, action: .none)
        
        let record = CKRecord(recordType: "MusicGroup", recordID: grupo.id)
        record["name"] = grupo.name as CKRecordValue
        record["members"] = [userRef] as CKRecordValue
        
        // Generates unique code for group
        let uniqueCode = try await generateUniqueGroupCode()
        grupo.groupCode = uniqueCode

        record["groupCode"] = grupo.groupCode as CKRecordValue
        
        do {
            try await db.save(record)
            print("Group created successfully: \(grupo.id)")
        } catch {
            print("Failed to create group: \(error.localizedDescription)")
        }
    }
    
    func fetchAllGroups(for userRecordID: CKRecord.ID) async throws -> [GroupModel] {
        // Creating query to find groups by user
        let userRef = CKRecord.Reference(recordID: userRecordID, action: .none)
        let groupPredicate = NSPredicate(format: "members CONTAINS %@", userRef)
        let groupQuery = CKQuery(recordType: "MusicGroup", predicate: groupPredicate)
        
        let (groupResults, _) = try await db.records(matching: groupQuery)
        let groupRecords = groupResults.compactMap { try? $0.1.get() }
        
        // COnverting CKRecords to GroupModels
        let groups = groupRecords.map { GroupModel(from: $0) }
        
        return groups
    }
    
    func fetchGroupByCode(code: String) async throws -> GroupModel? {
        let predicate = NSPredicate(format: "groupCode == %@", code)
        let query = CKQuery(recordType: "MusicGroup", predicate: predicate)
        
        let (results, _) = try await db.records(matching: query)
        guard let record = results.first?.1,
              case .success(let ckRecord) = record else {
            return nil
        }
        return GroupModel(from: ckRecord)
    }
    
    func fetchGroup(recordID: CKRecord.ID) async throws -> GroupModel {
        let record = try await db.record(for: recordID)
        
        let name = record["name"] as? String ?? ""
        let refs = record["members"] as? [CKRecord.Reference] ?? []
        
        let grupo = GroupModel(name: name)
        grupo.id = record.recordID
        grupo.members = refs
        return grupo
    }
    
    func editGroup(recordID: CKRecord.ID, newName: String, newDescricao: String, newQtdAlunos: Int, newMembers: [CKRecord.Reference]) async throws {
        // Note to development team: when implementing this function, you first need
        // to call fetchGroup to populate the fields, and then pass this function
        
        let record = try await db.record(for: recordID)
        
        record["name"] = newName as CKRecordValue
        record["members"] = newMembers as CKRecordValue
        
        do {
            try await db.save(record)
            print("Grupo editado com sucesso")
        } catch {
            print("Falha ao editar grupo")
            throw error
        }
    }
    
    func deleteGroup(_ group: GroupModel) async throws {
        // Creates references and predicates for the group
        let groupref = CKRecord.Reference(recordID: group.id, action: .none)
        let predicate = NSPredicate(format: "grupo == %@", groupref)
        
        // Creates queries for tarefa and desafio
        let queryTarefa = CKQuery(recordType: "Task", predicate: predicate)
        let queryDesafio = CKQuery(recordType: "Challenge", predicate: predicate)
        
        // Performs queries
        let (resultsTarefa, _) = try await db.records(matching: queryTarefa)
        let (resultsDesafio, _) = try await db.records(matching: queryDesafio)
        
        // Deletes related tarefas
        for (_, result) in resultsTarefa {
            if case .success(let record) = result {
                try await db.deleteRecord(withID: record.recordID)
                print("Deleted task: \(record.recordID.recordName)")
            }
        }
        
        // Deletes related desafios
        for (_, result) in resultsDesafio {
            if case .success(let record) = result {
                try await db.deleteRecord(withID: record.recordID)
                print("Deleted challenge: \(record.recordID.recordName)")
            }
        }
        
        // Deletes group
        try await db.deleteRecord(withID: group.id)
        print("Group deleted successfully: \(group.id.recordName)")
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
    
    
    // MARK: CRUD: Desafio
    func createChallenge(_ challenge: ChallengeModel) async throws {
        let record = CKRecord(recordType: "Challenge", recordID: challenge.id)
        
        if let groupRef = challenge.group {
            record["group"] = groupRef
        }
        record["title"] = challenge.title as CKRecordValue
        record["description"] = challenge.description as CKRecordValue
        record["whichChallenge"] = challenge.whichChallenge as CKRecordValue
        record["reward"] = challenge.reward as CKRecordValue
        record["startDate"] = challenge.startDate as CKRecordValue
        record["endDate"] = challenge.endDate as CKRecordValue
        
        do {
            try await db.save(record)
            print("Challenge created successfully: \(challenge.id.recordName)")
        } catch {
            print("Failed to create challenge: \(error.localizedDescription)")
        }
    }
    
    // Fetching challenges from teacher's view screen
    func fetchAllChallenges(for userRecordID: CKRecord.ID) async throws -> [ChallengeModel] {
        // Finding all groups the user belongs to
        let userRef = CKRecord.Reference(recordID: userRecordID, action: .none)
        let groupPredicate = NSPredicate(format: "members CONTAINS %@", userRef)
        let groupQuery = CKQuery(recordType: "MusicGroup", predicate: groupPredicate)

        let (groupResults, _) = try await db.records(matching: groupQuery)
        let groupRecords = groupResults.compactMap { try? $0.1.get() }

        // Extracting group references to use in challenge query
        let groupRefs = groupRecords.map { CKRecord.Reference(recordID: $0.recordID, action: .none) }

        // Fetching challenges for those groups
        var allChallenges: [ChallengeModel] = []

        for groupRef in groupRefs {
            let challengePredicate = NSPredicate(format: "group == %@", groupRef)
            let challengeQuery = CKQuery(recordType: "Challenge", predicate: challengePredicate)

            let (challengeResults, _) = try await db.records(matching: challengeQuery)
            let challengeRecords = challengeResults.compactMap { try? $0.1.get() }

            // Convert each CKRecord into a ChallengeModel
            let challenges = challengeRecords.map { ChallengeModel(from: $0) }
            allChallenges.append(contentsOf: challenges)
        }

        return allChallenges.sorted { $0.endDate > $1.endDate }
    }
    
    // Fetching a single challenge from recordID
    func fetchChallenge(recordID: CKRecord.ID) async throws -> ChallengeModel {
        let record = try await db.record(for: recordID)
        return ChallengeModel(from: record)
    }
    
    func editChallenge(recordID: CKRecord.ID, newTitle: String, newDescription: String, newReward: Int, newStartDate: Date, newEndDate: Date) async throws {
        // Note to development team: when implementing this function, you first need
        // to call fetchChallenge to populate the fields, and then pass this function
        let record = try await db.record(for: recordID)
        
        record["title"] = newTitle as CKRecordValue
        record["description"] = newDescription as CKRecordValue
        record["reward"] = newReward as CKRecordValue
        record["startDate"] = newStartDate as CKRecordValue
        record["endDate"] = newEndDate as CKRecordValue
        
        do {
            try await db.save(record)
            print("Successfully updated challenge")
        } catch {
            print("Failed to update challenge")
            throw error
        }
    }

    func deleteChallenge(_ challenge: ChallengeModel) async throws {
        try await db.deleteRecord(withID: challenge.id)
        print("Challenge deleted successfully: \(challenge.title)")
    }
    
    // MARK: CRUD: Tarefa
    func createTask(_ task: TaskModel) async throws {
        let record = CKRecord(recordType: "Task", recordID: task.id)
        
        record["studentAudio"] = task.studentAudio as CKRecordValue
        record["student"] = task.student as CKRecordValue
        record["title"] = task.title as CKRecordValue
        record["description"] = task.description as CKRecordValue
        record["reward"] = task.reward as CKRecordValue
        record["startDate"] = task.startDate as CKRecordValue
        record["endDate"] = task.endDate as CKRecordValue
        
        do {
            try await db.save(record)
            print("Task created successfully: \(task.title)")
        } catch {
            print("Failed to create task: \(error.localizedDescription)")
        }
    }
    
    // Fetching all tasks related to a particular user
    func fetchAllTasks(for userRecordID: CKRecord.ID) async throws -> [TaskModel] {
        let userRef = CKRecord.Reference(recordID: userRecordID, action: .none)
        let taskPredicate = NSPredicate(format: "members CONTAINS %@", userRef)
        let taskQuery = CKQuery(recordType: "Task", predicate: taskPredicate)
        
        let (taskResults, _) = try await db.records(matching: taskQuery)
        let taskRecords = taskResults.compactMap { try? $0.1.get() }
        
        // Converting CKRecords to TaskModels
        let tasks = taskRecords.map { TaskModel(from: $0) }
        
        return tasks
    }

    // Fetching a specific task from recordID
    func fetchTask(recordID: CKRecord.ID) async throws -> TaskModel {
        let record = try await db.record(for: recordID)
        return TaskModel(from: record)
    }

    func editTask(recordID: CKRecord.ID, newTitle: String, newDescription: String, newReward: Int, newStartDate: Date, newEndDate: Date) async throws {
        // Note to development team: when implementing this function, you first need
        // to call fetchTask to populate the fields, and then pass this function
        let record = try await db.record(for: recordID)
        
        record["title"] = newTitle as CKRecordValue
        record["description"] = newDescription as CKRecordValue
        record["reward"] = newReward as CKRecordValue
        record["startDate"] = newStartDate as CKRecordValue
        record["endDate"] = newEndDate as CKRecordValue
        
        do {
            try await db.save(record)
            print("Successfully updated task")
        } catch {
            print("Failed to update task")
            throw error
        }
    }
    
    func deleteTask(_ task: TaskModel) async throws {
        try await db.deleteRecord(withID: task.id)
        print("Task deleted successfully: \(task.title)")
    }
    
    // MARK: Auxiliary functions
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
        
        return TaskModel(
            title: latestRecord["title"] as? String ?? "",
            description: latestRecord["description"] as? String ?? "",
            student: latestRecord["student"] as! CKRecord.Reference,
            startDate: latestRecord["startDate"] as? Date ?? Date(),
            endDate: latestRecord["endDate"] as? Date ?? Date()
        )
    }
    
    func fetchLatestChallenge(for userRecordID: CKRecord.ID, in db: CKDatabase) async throws -> ChallengeModel? {
        let allChallenges = try await fetchAllChallenges(for: userRecordID)
        
        // Filter for completed challenges: those whose endDate is in the past
        let completedChallenges = allChallenges.filter { $0.endDate < Date() }
        
        // Sort by endDate descending (latest first)
        let sortedChallenges = completedChallenges.sorted { $0.endDate > $1.endDate }
        
        return sortedChallenges.first
    }
    
    func generateUniqueGroupCode() async throws -> String {
        while true {
            let code = String(format: "%06d", Int.random(in: 0...999_999))
            let predicate = NSPredicate(format: "groupCode == %@", code)
            let query = CKQuery(recordType: "MusicGroup", predicate: predicate)
            let (results, _) = try await db.records(matching: query)
            
            if results.isEmpty {
                return code
            }
        }
    }
    
    func generalSearch(prompt: String, userRecordID: CKRecord.ID) async throws -> (groups: [GroupModel], challenges: [ChallengeModel], tasks: [TaskModel]) {
        let groups: [GroupModel] = try await fetchAllGroups(for: userRecordID)
        let challenges: [ChallengeModel] = try await fetchAllChallenges(for: userRecordID)
        let tasks: [TaskModel] = try await fetchAllTasks(for: userRecordID)
        
        return (groups, challenges, tasks)
    }

}
