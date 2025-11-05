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
                Circle()
                    .foregroundStyle(Color(red: 0.65, green: 0.13, blue: 0.29))
                    .frame(height: 130)
                    .padding()
                
                Image(systemName: "music.note")
                    .font(.system(size: 70))
                    .foregroundStyle(.white)
            }
        }
        
        Text("Sign Up")
            .font(.system(size: 30))
            .padding(.vertical, 30)
        
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(red: 0.65, green: 0.13, blue: 0.29))
                    .frame(width: 24, height: 24)
                
                if aceite {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color(red: 0.65, green: 0.13, blue: 0.29))
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
        
        if aceite {
            Button("Entrar") {
                viewModel.finishRegistration()
            }
        }

    }
}

#Preview {
    TermosView()
}
