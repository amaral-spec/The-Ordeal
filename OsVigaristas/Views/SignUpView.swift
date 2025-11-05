//
//  SignUpView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 03/11/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var nome: String = ""
    @State private var isProfessor: Bool = false
    @State private var mostrarTermos: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundStyle(Color(red: 0.65, green: 0.13, blue: 0.29))
                    .frame(height: 130)
                    .padding()
                
                Image(systemName: "music.note")
                    .font(.system(size: 70))
                    .foregroundStyle(.white)
            }
            
            Text("Sign Up")
                .font(.system(size: 30))
                .padding(.vertical, 30)
            
            TextField("Nome de usuário", text: $nome)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.gray)
                )
                .padding(.horizontal)
          
            HStack {
                Text("Você é um professor?")
                Spacer()
                Picker ("", selection: $isProfessor){
                    Text("Sim").tag(true)
                    Text("Não").tag(false)
                }
                .pickerStyle(.menu)
                .tint(.black)
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.gray)
            )
            .padding(.horizontal)
            
            Button(action: {
                //tela de termos
            }) {
                Text("Continuar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.65, green: 0.13, blue: 0.29))
                    .cornerRadius(50)
            }
            .padding()
            .padding(.top, 70)
            
            Button(action: {
                mostrarTermos = true
            }) {
                Text("Termos e Condições")
                    .font(.footnote)
                    .foregroundStyle(Color(red: 0.65, green: 0.13, blue: 0.29))
            }
        }
        .sheet(isPresented: $mostrarTermos) {
            TermosView()
        }
    }
}

#Preview {
    SignUpView()
}
