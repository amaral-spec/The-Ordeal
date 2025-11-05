//
//  AuthService.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 04/11/25.
//

import Foundation
import AuthenticationServices
import Combine

@MainActor
final class AuthService: NSObject, ObservableObject {
    static let shared = AuthService()
    
    @Published private(set) var isLoggedIn: Bool = false
    @Published private(set) var appleUserID: String = ""
    @Published private(set) var currentUser: Usuarios = Usuarios(isProfessor: false, nome: "", desafios: [])
    
    private let userDefaults = UserDefaults.standard
    
    private override init() {
        super.init()
        loadSession()
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
        currentUser.isProfessor = false
        
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
            
            if isUserRegistered(userId: userId) {
                loadUser(userId: userId)
                isLoggedIn = true
                return .existingUser
            } else {
                // Novo usuário
                let nome = credential.fullName?.givenName ?? "Novo Usuário"
                currentUser = Usuarios(
                    isProfessor: false,
                    nome: nome,
                    desafios: []
                )
                currentUser.hasCompletedOnboarding = false
                
                appleUserID = userId
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
        
        currentUser = Usuarios(
            isProfessor: isProfessor,
            nome: nome,
            desafios: []
        )
        currentUser.hasCompletedOnboarding = hasCompletedOnboarding
    }
    
    // MARK: - Registration
    
    func makeRegistration(isProfessor: Bool, nome: String? = nil) {
        guard !appleUserID.isEmpty else { return }
        
        currentUser.isProfessor = isProfessor
        if let nome = nome { currentUser.nome = nome }
    }
    
    func finishRegistration() {
        guard !appleUserID.isEmpty else { return }
        
        saveSession(for: appleUserID)
        isLoggedIn = true
    }
    
    func markOnboardingComplete() {
        guard !appleUserID.isEmpty else { return }
        currentUser.hasCompletedOnboarding = true
        userDefaults.set(true, forKey: "user_\(appleUserID)_hasCompletedOnboarding")
    }
}

enum LoginResult {
    case newUser
    case existingUser
}

enum AuthError: LocalizedError {
    case invalidCredentials
}
