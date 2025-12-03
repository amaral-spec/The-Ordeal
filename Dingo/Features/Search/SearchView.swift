//
//  BuscarView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 10/11/25.
//

import SwiftUI

struct BuscarView: View {
    @EnvironmentObject var searchVM: SearchViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Grupos") {
                    ForEach(searchVM.generalSearch.1) { grupo in
                        Text(grupo.name)
                    }
                }
                Section("Alunos") {
                    ForEach(searchVM.generalSearch.0) { aluno in
                        Text(aluno.name)                }
                }
                Section("Tarefas") {
                    ForEach(searchVM.generalSearch.3) { task in
                        Text(task.title)
                    }
                }
                Section("Desafios") {
                    ForEach(searchVM.generalSearch.2) { challenge in
                        Text(challenge.title)
                    }
                }
            }
        }
    }
}

#Preview {
    BuscarView()
}
