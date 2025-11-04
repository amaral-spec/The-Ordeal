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
    
    @EnvironmentObject private var authVM: AuthViewModel
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundStyle(Color(red: 0.65, green: 0.13, blue: 0.29))
                .frame(height: 150)
            
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
        .modelContainer(for: Usuarios.self, inMemory: true)
        .environmentObject(AuthViewModel())
}
