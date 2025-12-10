//
//  ContentVazioView.swift
//  Dingo
//
//  Created by Gabriel Amaral on 10/12/25.
//

import SwiftUI

struct ContentVazioView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 52))
                .foregroundColor(.gray.opacity(0.6))
            
            Text("Busque alunos, grupos, desafios ou tarefas")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

