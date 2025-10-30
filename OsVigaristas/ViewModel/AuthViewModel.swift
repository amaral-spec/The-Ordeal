//
//  AuthViewModel.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 29/10/25.
//
import SwiftUI
import AuthenticationServices

@MainActor
class AuthViewModel: ObservableObject {
    @AppStorage("appleUserID") var appleUserID: String = ""
    @Published var logado = false
    
    init() {
        checkAppleSignInStatus()
    }
    
    func checkAppleSignInStatus() {
        guard !appleUserID.isEmpty else {
            logado = false
            return
        }
        
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: appleUserID) { state, _ in
            DispatchQueue.main.async {
                switch state {
                case .authorized:
                    self.logado = true
                case .revoked, .notFound:
                    self.logado = false
                    self.appleUserID = ""
                default:
                    break
                }
            }
        }
    }
    
    func handle(_ result: Result<ASAuthorization, Error>,) {
        switch result {
        case .success(let auth):
            if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                appleUserID = credential.user
                logado = true
            }
        case .failure(let error):
            print("Erro: ", error.localizedDescription)
        }
    }

    func logout() {
        appleUserID = ""
        logado = false
    }
}
