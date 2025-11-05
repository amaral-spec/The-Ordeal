//
//  AuthService.swift
//  OsVigaristas
//
//  Created by G Ludivik de Paula on 05/11/25.
//

import Foundation
import AuthenticationServices
import Combine
import SwiftData

@MainActor
final class AuthService: NSObject, ObservableObject {
    static let shared = AuthService()
    
    // MARK: - Public properties
    @Published private(set) var isLoggedIn: Bool = false
    @Published private(set) var appleUserID: String = ""
    @Published private(set) var currentUser: Usuarios = Usuarios(id: "")
    
    // MARK: - Private properties
    private let userDefaults = UserDefaults.standard
    private var modelContext: ModelContext?
    
    // MARK: - Init
    private override init() {
        super.init()
        loadSession()
    }
    
    // MARK: - Setup
    func configure(context: ModelContext) {
        self.modelContext = context
    }
    
    // MARK: - Sessão
    private func loadSession() {
        guard let userId = userDefaults.string(forKey: "appleUserID") else { return }
        appleUserID = userId
        loadUser(userId: userId)
        checkAppleSignInStatus()
    }
    
    private func saveSession(for userId: String) {
        userDefaults.set(userId, forKey: "appleUserID")
        userDefaults.set(currentUser.isProfessor, forKey: "user_\(userId)_isProfessor")
        userDefaults.set(currentUser.nome, forKey: "user_\(userId)_nome")
        userDefaults.set(currentUser.hasCompletedOnboarding, forKey: "user_\(userId)_hasCompletedOnboarding")
        userDefaults.set(true, forKey: "user_\(userId)_exists")
    }
    
    func logout() {
        userDefaults.removeObject(forKey: "appleUserID")
        appleUserID = ""
        currentUser = Usuarios(id: "")
        currentUser.hasCompletedOnboarding = false
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
            let nome = credential.fullName?.givenName ?? "Usuário Apple"
            let email = credential.email
            
            if isUserRegistered(userId: userId) {
                // Usuário local existente
                loadUser(userId: userId)
                isLoggedIn = true
                
                // Garante que também exista no CloudKit
                await syncWithCloudKit(userId: userId, nome: currentUser.nome ?? "", email: email)
                return .existingUser
                
            } else {
                // Novo usuário
                currentUser = Usuarios(id: "")
                currentUser.hasCompletedOnboarding = false
                appleUserID = userId
                
                // Cria também no CloudKit
                await syncWithCloudKit(userId: userId, nome: nome, email: email)
                
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
        
        if (!isUserRegistered(userId: appleUserID)) {
            return
        }
        
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: appleUserID) { state, _ in
            Task { @MainActor in
                switch state {
                case .authorized:
                    self.loadUser(userId: self.appleUserID)
                    self.isLoggedIn = true
                case .revoked, .notFound:
                    self.logout()
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - Usuário local
    private func isUserRegistered(userId: String) -> Bool {
        return userDefaults.bool(forKey: "user_\(userId)_exists")
    }
    
    private func loadUser(userId: String) {
        let isProfessor = userDefaults.bool(forKey: "user_\(userId)_isProfessor")
        let nome = userDefaults.string(forKey: "user_\(userId)_nome") ?? "Usuário Apple"
        let hasCompletedOnboarding = userDefaults.bool(forKey: "user_\(userId)_hasCompletedOnboarding")
        
        currentUser = Usuarios(id: userId,nome: nome, isProfessor: isProfessor)
        currentUser.hasCompletedOnboarding = hasCompletedOnboarding
    }
    
    // MARK: - Registro
    func makeRegistration(isProfessor: Bool, nome: String? = nil) {
        guard !appleUserID.isEmpty else { return }
        
        currentUser.isProfessor = isProfessor
        if let nome = nome { currentUser.nome = nome }
    }
    
    func finishRegistration() {
        guard !appleUserID.isEmpty else { return }
        
        saveSession(for: appleUserID)
        isLoggedIn = true
        
        Task {
            await syncWithCloudKit(userId: appleUserID, nome: currentUser.nome ?? "", email: nil)
        }
    }
    
    func markOnboardingComplete() {
        guard !appleUserID.isEmpty else { return }
        currentUser.hasCompletedOnboarding = true
        userDefaults.set(true, forKey: "user_\(appleUserID)_hasCompletedOnboarding")
    }
    
    // MARK: - iCloud / SwiftData
    private func syncWithCloudKit(userId: String, nome: String, email: String?) async {
        guard let modelContext else {
            print("ModelContext não configurado. Chame configure(context:) antes de logar.")
            return
        }
        
        let descriptor = FetchDescriptor<Usuarios>(predicate: #Predicate { $0.id == userId })
        
        do {
            let existing = try modelContext.fetch(descriptor)
            
            if existing.isEmpty {
                let newUser = Usuarios(id: userId, nome: nome, email: email)
                modelContext.insert(newUser)
                try modelContext.save()
                print("✅ Usuário salvo no iCloud (CloudKit).")
            } else {
                print("☁️ Usuário já existente no CloudKit.")
            }
            
        } catch {
            print("❌ Erro ao sincronizar com CloudKit:", error.localizedDescription)
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
