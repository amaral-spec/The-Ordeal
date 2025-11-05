//
//  AuthViewModel.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 29/10/25.
//
import SwiftUI
import AuthenticationServices


enum AuthFlowState: String {
    case login
    case signUp
    case completed
}

@MainActor
class AuthViewModel: ObservableObject {
    @AppStorage("appleUserID") var appleUserID: String = ""
    @AppStorage("authFlowState") var currentFlowStateRaw: String = AuthFlowState.login.rawValue
    
    @Published var logado = false
    
    var appState: AuthFlowState {
        get { AuthFlowState(rawValue: currentFlowStateRaw) ?? .login }
        set { currentFlowStateRaw = newValue.rawValue }
    }
    
    @Published var username: String = ""
    @Published var isTeacher: Bool = false

    init() {
        checkAppleSignInStatus()
    }
    
    func checkAppleSignInStatus() {
        guard !appleUserID.isEmpty else {
            appState = .login
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
                    self.logout()
                default:
                    break
                }
            }
        }
    }
    
    func handle(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                appleUserID = credential.user
                
                if let fullName = credential.fullName {
                    let givenName = fullName.givenName ?? ""
                    let familyName = fullName.familyName ?? ""
                    self.username = "\(givenName) \(familyName)".trimmingCharacters(in: .whitespaces)
                }
                
                logado = true
                appState = .signUp
            }
        case .failure(let error):
            print("Erro no Sign In with Apple: \(error.localizedDescription)")
        }
    }
    
    func didFinishSignUp(username: String, isTeacher: Bool) {
        self.username = username
        self.isTeacher = isTeacher
    }

    func didAcceptTerms() {
        appState = .completed
    }

    func logout() {
        appleUserID = ""
        logado = false
        appState = .login
        username = ""
        isTeacher = false
    }
}
