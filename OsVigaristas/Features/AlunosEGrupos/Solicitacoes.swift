//
//  Solicitacoes.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 18/11/25.
//

import SwiftUI

struct Solicitacoes: View {
    var onSolicitacoes: (() -> Void)?

    var body: some View {
        NavigationStack {
            ScrollView {
                List {
                    ForEach() {
                        
                    }
                }
            }
            .navigationTitle("Solicições")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            //carregar task
        }
    }
}

#Preview {
    Solicitacoes()
}
