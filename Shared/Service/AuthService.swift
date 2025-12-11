//
//  AuthService.swift
//  OsVigaristas
//
//  Created by G Ludivik de Paula on 05/11/25.
//

import Foundation
import AuthenticationServices
import Combine
import CloudKit

@MainActor
final class AuthService: NSObject, ObservableObject {
    static let shared = AuthService(persistenceServices: PersistenceServices())
    
    // MARK: - Public properties
    @Published private(set) var isLoggedIn: Bool = false
    @Published private(set) var appleUserID: String = ""
    @Published private(set) var currentUser: UserModel?
    
    // MARK: - Private properties
    private let userDefaults = UserDefaults.standard
    private let container = CKContainer.default()
    private var database: CKDatabase { container.publicCloudDatabase }
    
    // MARK: - Init
    private let persistenceServices: PersistenceServices   // agora é apenas referência externa

    init(persistenceServices: PersistenceServices) {
        self.persistenceServices = persistenceServices
        super.init()
        loadSession()
    }
    
    // MARK: - Sessão
    private func loadSession() {
        guard let userId = userDefaults.string(forKey: "appleUserID") else { return }
        appleUserID = userId
        Task {
            await loadUserFromCloudKit(userId: userId)
            checkAppleSignInStatus()
        }
    }
    
    private func saveSession(for userId: String) {
        userDefaults.set(userId, forKey: "appleUserID")
    }
    
    func logout() {
        userDefaults.removeObject(forKey: "appleUserID")
        appleUserID = ""
        currentUser = nil
        isLoggedIn = false
    }
    
    func changeType() {
        isLoggedIn = false
    }
    
    // MARK: - Apple Sign In
    func handleAppleSignIn(result: Result<ASAuthorization, Error>) async throws -> LoginResult {
        switch result {
        case .success(let auth):
            guard let credential = auth.credential as? ASAuthorizationAppleIDCredential else {
                throw AuthError.invalidCredentials
            }
            
            let userId = credential.user
            
            if let existingUser = await fetchUserFromCloudKit(userId: userId) {
                currentUser = existingUser
                appleUserID = userId
                isLoggedIn = true
                saveSession(for: userId)
                return .existingUser
            } else {
                // Novo usuário
                let newUser = UserModel(credential: credential)
                currentUser = newUser
                appleUserID = userId
//                await saveUserToCloudKit(newUser)
                saveSession(for: userId)
                return .newUser
            }
            
        case .failure(let error):
            print("Erro ao fazer login com Apple:", error.localizedDescription)
            throw error
        }
    }
    
    // MARK: - Estado de login
    func checkAppleSignInStatus() {
        
        guard !appleUserID.isEmpty else {
            isLoggedIn = false
            return
        }
        
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: appleUserID) { state, _ in
            Task { @MainActor in
                switch state {
                case .authorized:
                    if let existingUser = await self.fetchUserFromCloudKit(userId: self.appleUserID) {
                        self.currentUser = existingUser
                        self.isLoggedIn = true
                        self.saveSession(for: self.appleUserID)
                    }
                case .revoked, .notFound:
                    self.logout()
                default:
                    break
                }
            }
        }
        
     
    }
    
    // MARK: - CloudKit
    
    private func fetchUserFromCloudKit(userId: String) async -> UserModel? {
        do {
            let recordID = CKRecord.ID(recordName: userId)
            let record = try await database.record(for: recordID)
            return UserModel(from: record)
        } catch {
            print("⚠️ Usuário não encontrado no CloudKit: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func loadUserFromCloudKit(userId: String) async {
        if let user = await fetchUserFromCloudKit(userId: userId) {
            currentUser = user
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
    
    private func saveUserToCloudKit(_ user: UserModel) async {
        let record = user.toCKRecord()
        do {
            try await database.save(record)
            print("✅ Usuário salvo no CloudKit.")
        } catch {
            print("❌ Erro ao salvar usuário no CloudKit: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Registro
    func makeRegistration(isTeacher: Bool, name: String? = nil) {
        guard let currentUser else { return }
        currentUser.isTeacher = isTeacher
        if let name = name {
            currentUser.name = name
        }
    }
    
    func finishRegistration() {
        guard let currentUser else { return }
        saveSession(for: currentUser.id.recordName)
        isLoggedIn = true
        
        Task {
            await saveUserToCloudKit(currentUser)
        }
    }
    
    private func removeUserFromAllGroups() async {
        guard let userRecordID = currentUser?.id else { return }
        
        do {
            var listaGrupos = try await persistenceServices.fetchAllGroups()
            
            for grupo in listaGrupos {
                try await database.deleteRecord(withID: grupo.id)
            }
            
        } catch {
            print("❌ Erro ao buscar grupos do usuário: \(error.localizedDescription)")
        }
    }
    
    private func removeUserFromAllTask() async {
        guard let userRecordID = currentUser?.id else { return }
        
        do {
            var listaTasks = try await persistenceServices.fetchAllTasks()
            
            for task in listaTasks {
                try await database.deleteRecord(withID: task.id)
            }
            
        } catch {
            print("❌ Erro ao buscar grupos do usuário: \(error.localizedDescription)")
        }
    }
    
    
    func cancelRegistration() {
        // If there's no stored Apple ID, just clear local session
        guard !appleUserID.isEmpty else {
            logout()
            return
        }
        let recordID = CKRecord.ID(recordName: appleUserID)
        
        Task {
            print("🗑️ Iniciando remoção de todos os grupos...")
            await removeUserFromAllGroups()
            print("🗑️ Iniciando remoção de todas as tasks...")
            await removeUserFromAllTask()
            
            do {
                try await database.deleteRecord(withID: recordID)
                print("✅ User deleted successfully: \(recordID.recordName)")
            } catch {
                print("❌ Failed to delete user: \(error.localizedDescription)")
            }
            
            await MainActor.run {
                self.logout()
            }
        }
    }
}

// MARK: - Enums
enum LoginResult {
    case newUser
    case existingUser
}

enum AuthError: LocalizedError {
    case invalidCredentials
}
