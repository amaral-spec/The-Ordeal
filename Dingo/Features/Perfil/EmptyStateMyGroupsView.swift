//
//  EmptyStateView.swift
//  Dingo
//
//  Created by Ludivik de Paula on 09/12/25.
//


import SwiftUI

struct EmptyStateMyGroupsView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Ícone circular fornecido
            ZStack {
                Circle()
                    .frame(width: 50)
                    .foregroundColor(Color("RedCard")) // Certifique-se de ter essa cor no Assets
                    .opacity(0.15)
                
                Image(systemName: "music.pages.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Color("RedCard"))
            }
            .padding(.bottom, 8)

            // Textos fornecidos
            VStack(spacing: 8) {
                Text("Sem grupos")
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Você ainda não faz parte de nenhum grupo")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Centraliza na tela
        .padding()
    }
}
