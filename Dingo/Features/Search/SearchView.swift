//
//  BuscarView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 10/11/25.
//

import SwiftUI

struct BuscarView: View {
    @Binding var searchText: String
    @EnvironmentObject var searchVM: SearchViewModel

    var body: some View {
        VStack {
            
            if !searchVM.resultsLoaded && !searchVM.isLoading {
                ContentUnavailableView(
                    "Buscar",
                    systemImage: "magnifyingglass",
                    description: Text("Digite algo na barra acima para iniciar a pesquisa.")
                )
            }
            
            else if searchVM.isLoading {
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Buscando…")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
            }
            
            else {
                List {
                    Section("Alunos") {
                        if searchVM.generalSearch.0.isEmpty {
                            Text("Nenhum aluno encontrado.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(searchVM.generalSearch.0) { aluno in
                                Text(aluno.name)
                            }
                        }
                    }
                    
                    Section("Grupos") {
                        if searchVM.generalSearch.1.isEmpty {
                            Text("Nenhum grupo encontrado.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(searchVM.generalSearch.1) { grupo in
                                Text(grupo.name)
                            }
                        }
                    }
                    
                    Section("Desafios") {
                        if searchVM.generalSearch.2.isEmpty {
                            Text("Nenhum desafio encontrado.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(searchVM.generalSearch.2) { challenge in
                                Text(challenge.title)
                            }
                        }
                    }

                    Section("Tarefas") {
                        if searchVM.generalSearch.3.isEmpty {
                            Text("Nenhuma tarefa encontrada.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(searchVM.generalSearch.3) { task in
                                Text(task.title)
                            }
                        }
                    }
                }
            }
        }
        .animation(.default, value: searchVM.isLoading)
    }
}




