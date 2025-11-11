//
//  BuscarView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 10/11/25.
//

import SwiftUI

struct BuscarView: View {
    @EnvironmentObject var dataVM: DataViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Alunos") {
                    ForEach(dataVM.alunos) { aluno in
                        Text(aluno.nome)
                    }
                }
                
                Section("Grupos") {
                    ForEach(dataVM.grupos) { grupo in
                        Text(grupo.nome)
                    }
                }
            }
        }
    }
}

#Preview {
    BuscarView()
        .environmentObject(DataViewModel())
}
