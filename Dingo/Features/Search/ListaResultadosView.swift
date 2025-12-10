//
//  ListaResultadosView.swift
//  Dingo
//
//  Created by Gabriel Amaral on 10/12/25.
//

import SwiftUI

struct ListaResultadosView: View {
    @EnvironmentObject var searchVM: SearchViewModel
    
    var body: some View {
        List {
            Section("Grupos") {
                ForEach(searchVM.generalSearch.1) { grupo in
                    Text(grupo.name)
                }
            }

            Section("Alunos") {
                ForEach(searchVM.generalSearch.0) { aluno in
                    Text(aluno.name)
                }
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

