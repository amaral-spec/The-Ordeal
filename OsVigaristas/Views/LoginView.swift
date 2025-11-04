//
//  LoginView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 03/11/25.
//

import SwiftUI
import SwiftData
import AuthenticationServices

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Usuarios]
    @StateObject private var authVM = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if authVM.logado {
                    VStack {
                        Text("Logado")
                            .padding() // tela depois que o usuario logar
                        
                        Button("Logout") {
                            authVM.logout()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    VStack {
                        Rectangle()
                            .foregroundStyle(Color(red: 0.65, green: 0.13, blue: 0.29))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                        
                        Text("Login or sign up")
                            .font(.title2)
                            .padding(.bottom, 50)
                        SignInWithAppleButton(
                            .signIn,
                            onRequest: { request in
                                request.requestedScopes = [.fullName, .email]
                            },
                            onCompletion: { result in
                                authVM.handle(result)
                            }
                        )
                        .frame(height: 45)
                        .padding()
                        .signInWithAppleButtonStyle(.black)
                        
                        Spacer()
                    }
                }
            }
        }
        .backgroundStyle(.white)
    }
}

#Preview {
    LoginView()
        .modelContainer(for: Usuarios.self, inMemory: true)
}
