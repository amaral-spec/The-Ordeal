////
////  AuthViewModel.swift
////  OsVigaristas
////
////  Created by Gabriel Amaral on 29/10/25.
////
//import SwiftUI
//import AuthenticationServices
//import SwiftData
//
//
//@MainActor
//class AuthViewModel: ObservableObject {
//    @AppStorage("appleUserID") var appleUserID: String = ""
//    @Published var logado = false
//    @Published var mensagem: String = ""
//    @Published var email = ""
//    @Published var nome = ""
//    
//    private var modelContext: ModelContext
//    
//    init(modelContext: ModelContext) {
//        self.modelContext = modelContext
//        checkAppleSignInStatus()
//    }
//    
//    
//    // MARK: Authentication functions
//    func checkAppleSignInStatus() {
//        guard !appleUserID.isEmpty else {
//            logado = false
//            return
//        }
//        
//        let provider = ASAuthorizationAppleIDProvider()
//        provider.getCredentialState(forUserID: appleUserID) { state, _ in
//            DispatchQueue.main.async {
//                switch state {
//                case .authorized:
//                    self.logado = true
//                case .revoked, .notFound:
//                    self.logado = false
//                    self.appleUserID = ""
//                default:
//                    break
//                }
//            }
//        }
//    }
//    
//    func handle(_ result: Result<ASAuthorization, Error>,) {
//        switch result {
//        case .success(let auth):
//            if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
//                appleUserID = credential.user
//                nome = credential.fullName?.givenName ?? ""
//                email = credential.email ?? ""
//                logado = true
//                
//                Task {
//                    let _ = await checkNewUser(id: appleUserID, email: email)
//                }
//            }
//            
//        case .failure(let error):
//            print("Erro: ", error.localizedDescription)
//        }
//    }
//    
//    func logout() {
//        appleUserID = ""
//        logado = false
//    }
//
//    func checkNewUser(id: String, email: String?) async -> Bool {
//        let fetchDescriptor = FetchDescriptor<Usuarios>(predicate: #Predicate { $0.id == id})
//        do {
//            let existing = try modelContext.fetch(fetchDescriptor)
//            if existing.isEmpty {
//                let newUser = Usuarios(id: appleUserID, nome: nome, email: email)
//                modelContext.insert(newUser)
//                
//                try modelContext.save()
//                
//                print("New user saved and queued for CloudKit sync.")
//                return true
//            } else {
//                print("Existing user found")
//                return false
//            }
//        } catch {
//            print("Error checking user:", error)
//            return false
//        }
//    }
//}
//
