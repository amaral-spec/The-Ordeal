//
//  CriarGrupoView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 10/11/25.
//

import SwiftUI

struct CriarGrupoView: View {
    @State private var grupoNome: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack() {
                TextField("Nome do grupo", text: $grupoNome)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(.gray.opacity(0.2))
                    )
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Criar gripo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }.foregroundStyle(Color.accentColor)
                    
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        //funcao para crar grupo no ck
                    }) {
                        Image(systemName: "arrow.up")
                    }
                }
            }

        }
    }
}

#Preview {
    CriarGrupoView()
}
