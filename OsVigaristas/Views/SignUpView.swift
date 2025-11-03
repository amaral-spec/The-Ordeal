//
//  SignUpView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 03/11/25.
//

import SwiftUI

struct SignUpView: View {
    @State private var nome: String = ""
    @State private var email: String = ""
    @State private var isProfessor: Bool = false
    @State private var mostrarTermos: Bool = false
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.headline)
            
            TextField("Nome", text: $nome)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal)
            TextField("Email", text: $email)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal)
            Toggle("Professor", isOn: $isProfessor)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
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
                    .cornerRadius(10)
            }
            .padding()
            
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
