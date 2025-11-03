//
//  TermosView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 03/11/25.
//

import SwiftUI

struct TermosView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var aceite: Bool = false
    
    var body: some View {
        Text("Fazer termos baseado no nosso app")
            .foregroundStyle(Color(red: 0.65, green: 0.13, blue: 0.29))
        
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
            .onTapGesture { aceite.toggle() }
            
            Text("Aceito os termos")
                .onTapGesture { aceite.toggle() }
        }
        .padding()
        
        Button(action: {
            dismiss()
        }) {
            Text("Fechar")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.65, green: 0.13, blue: 0.29))
                .cornerRadius(10)
            
        }
        .padding()
    }
}

#Preview {
    TermosView()
}
