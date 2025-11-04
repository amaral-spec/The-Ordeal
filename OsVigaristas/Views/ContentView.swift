//
//  ContentView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 27/10/25.
//

import SwiftUI
import SwiftData
import AuthenticationServices

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var usuarios: [Usuarios]
    @StateObject var authVM: AuthViewModel
    
    // variaveis para login/cadastro
    @State private var email = ""
    @State private var senha = ""
    @State private var nome = ""
    @State private var isProfessor = false
    @State private var modoCadastro = false
    
    var body: some View {
        NavigationStack {
            Group {
                if authVM.logado {
                    VStack {
                        Text("Logado")
                            .padding()
                        
                        Button("Logout") {
                            authVM.logout()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    Text("Bem-vindo ao Os Vigaristas")
                    
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
                }
            }
        }
        .backgroundStyle(.white)
    }
}

