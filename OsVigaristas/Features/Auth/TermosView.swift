//
//  TermosView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 03/11/25.
//

import SwiftUI

struct TermosView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var aceite: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                Image("Logo")
                    .scaleEffect(0.5)
                    .frame(height: 150)
                    .padding()
            }
        }
        
        Text("Sign Up")
            .font(.system(size: 30))
            .padding(.vertical, 30)
        
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.accentColor)
                    .frame(width: 24, height: 24)
                
                if aceite {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color.accentColor)
                        .font(.system(size: 16, weight: .bold))
                }
            }
            .onTapGesture {
                aceite.toggle()
            }
            Text("Aceito os termos")
                .onTapGesture { aceite.toggle() }
            
        }
        .padding()
        
        Button(action: {
            // Fazer esse finishregistration alterar dados para icloud, salvar la apenas depois dessa funcao ser chamada
            viewModel.finishRegistration()
        }) {
            Text("Entrar no app")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(aceite ? Color.accentColor : Color.gray)
                .cornerRadius(50)
            
        }
        .disabled(!aceite)
        .padding()

    }
}

#Preview {
    TermosView()
}
