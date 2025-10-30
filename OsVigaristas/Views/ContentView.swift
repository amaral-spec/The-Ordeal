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
    @Query private var items: [Usuarios]
    @StateObject private var authVM = AuthViewModel()

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
                    VStack {
                        Text("Bem-vindo!")
                            .font(.title2)
                            .padding(.bottom)
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
        }
        .backgroundStyle(.white)
    }
    
    private func addItem() {
        withAnimation {
            // criar o objeto
//            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Usuarios.self, inMemory: true)
}
