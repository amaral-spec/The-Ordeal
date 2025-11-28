//
//  CriarGrupoViewModel.swift
//  OsVigaristas
//
//  Created by Júlio Zampietro on 10/11/25.
//

import CloudKit
import SwiftUI


@MainActor
class PersistenceServices: NSObject, ObservableObject {
    static let shared = PersistenceServices()
    
    let db = CKContainer.default().publicCloudDatabase
    
    // MARK: CRUD: Usuarios
    func fetchUserForProfile() async throws -> UserModel {
        guard let currentUser = AuthService.shared.currentUser else {
            throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No user loggoed in"])
        }
        
        let record = try await db.record(for: currentUser.id)
        
        let name = record["name"] as? String ?? ""
        let email = record["email"] as? String ?? ""
        let isTeacher = record["isTeacher"] as? Bool ?? false
        let streak = record["streak"] as? Int ?? 0
        let points = record["points"] as? Int ?? 0
        let lastTask: TaskModel?
        let lastChallenge: ChallengeModel?
        let profileImageName = record["profileImageName"]
        var profileImage: UIImage?

        // Profile image from CloudKit
        if let asset = record["profileImage"] as? CKAsset,
           let url = asset.fileURL,
           let data = try? Data(contentsOf: url) {
            profileImage = UIImage(data: data)
        }
        
        let usuario = UserModel(from: record)
        usuario.id = record.recordID
        usuario.email = email
        usuario.isTeacher = isTeacher
        usuario.streak = streak
        usuario.points = points
        usuario.lastTask = try await fetchLatestTask(for: currentUser.id, in: db)
        usuario.lastChallenge = try await fetchLatestChallenge(for: currentUser.id, in: db)
//        usuario.profileImageName = profileImageName
        usuario.profileImage = profileImage
        return usuario
    }
    
    func fetchUserForTask() async throws -> [UserModel] {
        guard let currentUser = AuthService.shared.currentUser else {
            throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No user loggoed in"])
        }
        
        let groups = try await fetchAllGroups()

        let memberReferences = groups.flatMap { $0.members } // [CKRecord.Reference]

        let memberIDs = Set(memberReferences.map { $0.recordID })
            .subtracting([currentUser.id])  // exclude the user themselves

        var users: [UserModel] = []

        for id in memberIDs {
            let record = try await db.record(for: id)
            let user = UserModel(from: record)
            users.append(user)
        }

        return users
    }
    
    func fetchChallengeMembers(recordReference: CKRecord.Reference) async throws -> [UserModel] {
        var groupMembers: [UserModel] = []
        let groupId = recordReference.recordID
        let group = try await fetchGroup(recordID: groupId)
        
        for userRef in group.members {
            // Loads record from CloudKit
            let individualMember = try await db.record(for: userRef.recordID)
            // transforms record into userModel
            let userModel = UserModel(from: individualMember)
            // Adds userModel to groupMembers
            groupMembers.append(userModel)
        }
        
        return groupMembers
    }
    
    // Fetch all students (users where isTeacher == false)
    func fetchAllStudents() async throws -> [UserModel] {
        let predicate = NSPredicate(format: "isTeacher == %@", NSNumber(value: false))
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        let (results, _) = try await db.records(matching: query)
        let records: [CKRecord] = results.compactMap { try? $0.1.get() }
        let users = records.map { UserModel(from: $0) }
        return users
    }
    
    func editUser(newName: String, isTeacher: Bool) async throws {
        guard let currentUser = AuthService.shared.currentUser else {
            throw NSError(domain: "AuthError", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "No user logged in"
            ])
        }

        let record = try await db.record(for: currentUser.id)

        record["name"] = newName as CKRecordValue
        record["isTeacher"] = isTeacher as CKRecordValue

        try await db.save(record)
    }
    
    func updateProfileImage(_ image: UIImage) async throws {
        guard let currentUser = AuthService.shared.currentUser else {
            throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No user loggoed in"])
        }
        
        // Create temp file for CKAsset
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".png")
        if let data = image.pngData() {
            try? data.write(to: url)
            
            do {
                let record = try await db.record(for: currentUser.id)
                record["profileImage"] = CKAsset(fileURL: url)
                
                let savedRecord = try await db.save(record)
                DispatchQueue.main.async {
                    AuthService.shared.currentUser?.profileImage = image
                    print("Profile image updated for \(savedRecord.recordID.recordName)")
                }
            } catch {
                print("Failed to update profile image: \(error)")
            }
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
    
    func fetchAllGroups() async throws -> [GroupModel] {
        guard let currentUser = AuthService.shared.currentUser else {
            throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No user loggoed in"])
        }
        
        // Creating query to find groups by user
        let userRef = CKRecord.Reference(recordID: currentUser.id, action: .none)
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
    
    // MARK: Grupo: pedidos e membros
    func askToJoinGroup(to grupo: GroupModel) async throws {
        guard let currentUser = AuthService.shared.currentUser else {
            throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No user loggoed in"])
        }
        
        let record = try await db.record(for: grupo.id)
        let newRef = CKRecord.Reference(recordID: currentUser.id, action: .none)
        
        // Checks if user is already in group
        var members = record["members"] as? [CKRecord.Reference] ?? []
        if members.contains(where: { $0.recordID == newRef.recordID }) {
            print("Student already in group.")
            return
        }
        
        var joinSolicitations = record["joinSolicitations"] as? [CKRecord.Reference] ?? []
        
        if !joinSolicitations.contains(where: { $0.recordID == newRef.recordID }) {
            joinSolicitations.append(newRef)
            record["joinSolicitations"] = joinSolicitations

            try await db.save(record)
        } else {
            print("User already in solicitations list.")
        }
    }
    
    func fetchSolicitations() async throws -> [CKRecord.ID: [UserModel]] {
        var result: [CKRecord.ID: [UserModel]] = [:]

        // Fetch all groups of this teacher
        let grupos = try await fetchAllGroups()

        for grupo in grupos {
            
            guard let solicitations = grupo.joinSolicitations,
                  !solicitations.isEmpty else {
                continue // skip groups with no solicitations
            }
            
            var users: [UserModel] = []

            for ref in solicitations {
                do {
                    let userRecord = try await db.record(for: ref.recordID)
                    let user = UserModel(from: userRecord)
                    users.append(user)
                } catch {
                    print("Failed to fetch user \(ref.recordID): \(error)")
                }
            }

            if !users.isEmpty {
                result[grupo.id] = users
            }
        }

        return result
    }

    
    func acceptSolicitation(to grupo: GroupModel, usuario: UserModel) async throws {
        let record = try await db.record(for: grupo.id)
        
        var members = record["members"] as? [CKRecord.Reference] ?? []
        var joinSolicitations = record["joinSolicitations"] as? [CKRecord.Reference] ?? []
        let newRef = CKRecord.Reference(recordID: usuario.id, action: .none)
        
        // Avoid duplicates
        if !members.contains(where: { $0.recordID == newRef.recordID }) {
            // Adds user to members, removes user from joinSolicitations
            members.append(newRef)
            joinSolicitations.removeAll { $0.recordID == newRef.recordID }
            
            record["members"] = members
            record["joinSolicitations"] = joinSolicitations
            
            try await db.save(record)
        } else {
            print("Student already in group.")
        }
    }
    
    func rejectSolicitation(to grupo: GroupModel, usuario: UserModel) async throws {
        let record = try await db.record(for: grupo.id)
        var joinSolicitations = record["joinSolicitations"] as? [CKRecord.Reference] ?? []
        let newRef = CKRecord.Reference(recordID: usuario.id, action: .none)
        
        joinSolicitations.removeAll { $0.recordID == newRef.recordID }
        record["joinSolicitations"] = joinSolicitations
        
        try await db.save(record)
    }
    
    func removeMember(from grupo: GroupModel, usuario: UserModel) async throws {
        let record = try await db.record(for: grupo.id)
        
        var members = record["members"] as? [CKRecord.Reference] ?? []
        members.removeAll { $0.recordID == usuario.id }
        
        record["members"] = members
        
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
    func fetchAllChallenges() async throws -> [ChallengeModel] {
        guard let currentUser = AuthService.shared.currentUser else {
            throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No user loggoed in"])
        }
        
        // Finding all groups the user belongs to
        let userRef = CKRecord.Reference(recordID: currentUser.id, action: .none)
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
        if let audio = task.studentAudio {
            record["studentAudio"] = audio as CKRecordValue
        }
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
    func fetchAllTasks() async throws -> [TaskModel] {
        guard let currentUser = AuthService.shared.currentUser else {
            throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No user loggoed in"])
        }
        
        let userRef = CKRecord.Reference(recordID: currentUser.id, action: .none)
        let taskPredicate = NSPredicate(format: "student CONTAINS %@", userRef)
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
        let predicate = NSPredicate(format: "student CONTAINS %@", CKRecord.Reference(recordID: userRecordID, action: .none))
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
        
        return TaskModel(from: latestRecord)
    }
    
    func fetchLatestChallenge(for userRecordID: CKRecord.ID, in db: CKDatabase) async throws -> ChallengeModel? {
        let allChallenges = try await fetchAllChallenges()
        
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
    
    func generalSearch(prompt: String, userRecordID: CKRecord.ID) async throws -> ([GroupModel], [ChallengeModel], [TaskModel]) {
        // Function that creates predicates/queries for each type (group, challenge, task)
        // Returns arrays with all objects found that match both the user's prompt
        // and their user id
        let userRef = CKRecord.Reference(recordID: userRecordID, action: .none)

        // Fetching groups from prompt
        let groupPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "name CONTAINS %@", prompt),
            NSPredicate(format: "members CONTAINS %@", userRef)
        ])
        let groupQuery = CKQuery(recordType: "MusicGroup", predicate: groupPredicate)
        let (groupResults, _) = try await db.records(matching: groupQuery)
        let groupRecords = groupResults.compactMap { try? $0.1.get() }
        let groups = groupRecords.map { GroupModel(from: $0) }
        
        // Fetching challenges from prompt
        let userGroups = try await fetchAllGroups()
        let groupRefs = userGroups.map { CKRecord.Reference(recordID: $0.id, action: .none) }
        
        let challengeNamePredicate = NSPredicate(format: "name CONTAINS %@", prompt)
        let groupListPredicate = NSPredicate(format: "group IN %@", groupRefs)
        let challengePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            challengeNamePredicate,
            groupListPredicate
        ])
        
        let challengeQuery = CKQuery(recordType: "Challenge", predicate: challengePredicate)
        let (challengeResults, _) = try await db.records(matching: challengeQuery)
        let challengeRecords = challengeResults.compactMap { try? $0.1.get() }
        let challenges = challengeRecords.map { ChallengeModel(from: $0) }
        
        // Fetching tasks from prompt
        let taskPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "title CONTAINS %@", prompt),
            NSPredicate(format: "student == %@", userRef)
        ])
        let taskQuery = CKQuery(recordType: "Task", predicate: taskPredicate)
        let (taskResults, _) = try await db.records(matching: taskQuery)
        let taskRecords = taskResults.compactMap { try? $0.1.get() }
        let tasks = taskRecords.map { TaskModel(from: $0) }
        
        return (groups, challenges, tasks)
    }
    
    // MARK: Challenge Session
    func startChallengeSession(challengeID: CKRecord.ID, userID: CKRecord.ID) async throws -> CKRecord.ID {
        let record = CKRecord(recordType: "ChallengeSession")

        record["challenge"] = CKRecord.Reference(recordID: challengeID, action: .none)
        record["user"] = CKRecord.Reference(recordID: userID, action: .none)
        record["timestamp"] = Date() as CKRecordValue
        record["isDoing"] = true as CKRecordValue

        let saved = try await db.save(record)
        return saved.recordID
    }

    
    func updateChallengeSession(sessionID: CKRecord.ID) async throws {
        let record = try await db.record(for: sessionID)
        record["timestamp"] = Date() as CKRecordValue
        try await db.save(record)
    }

    func isChallengeLocked(challengeID: CKRecord.ID) async -> Bool {
        let challengeRef = CKRecord.Reference(recordID: challengeID, action: .none)

        // timeout de 90s
        let limit = Date().addingTimeInterval(-90)

        let predicate = NSPredicate(
            format: "challenge == %@ AND isDoing == true AND timestamp > %@",
            challengeRef,
            limit as CVarArg
        )

        let query = CKQuery(recordType: "ChallengeSession", predicate: predicate)

        do {
            let (results, _) = try await db.records(matching: query)
            return results.count > 0
        } catch {
            print("Error checking lock:", error)
            return false
        }
    }


    func deleteChallengeSession(sessionID: CKRecord.ID) async throws {
        try await db.deleteRecord(withID: sessionID)
    }

    
}


