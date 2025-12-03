//
//  AlunosView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 18/11/25.
//

import SwiftUI

let columns: [GridItem] = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
]

struct AlunosView: View {
    @ObservedObject var alunoVM: AlunosViewModel
    let onNavigate: (AlunosCoordinatorView.Route) -> Void
    
    var body: some View {
        Picker("", selection: $alunoVM.selectedMode) {
            ForEach(Mode.allCases, id: \.self) { mode in
                Text(mode.rawValue)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        
        VStack(spacing: -15) {
            // MARK: - ALUNOS
            if alunoVM.selectedMode == .Alunos {
                if alunoVM.isStudentsEmpty {
                    emptyStateView(
                        image: "person.3.fill",
                        title: "Sem alunos",
                        subtitle: "Você ainda não possui alunos"
                    )
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            // MARK: - Puxar do CloudKit
                            ForEach(alunoVM.students) { aluno in
                                AlunosViewCard(aluno: aluno)
                            }
                            .padding(8)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                        }
                    }
                    .padding(8)
                }
                
                // MARK: - GRUPOS
            } else {
                if alunoVM.isGroupsEmpty {
                    emptyStateView(
                        image: "person.3.fill",
                        title: "Sem grupos",
                        subtitle: "Você ainda não possui grupos"
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(alunoVM.grupos) { grupo in
                                GroupCard(grupo: grupo)
                                    .onTapGesture {
                                        onNavigate(AlunosCoordinatorView.Route.detailGroup(grupo))
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Alunos")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button { alunoVM.criarGrupo = true } label: {
                    Image(systemName: "person.2.badge.plus.fill")
                        .foregroundStyle(Color(.accent))
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    onNavigate(.solicitation)
                } label: {
                    Image(systemName: "person.fill.checkmark.and.xmark")
                        .foregroundStyle(Color(.accent))
                }
            }
        }
        .task {
            await alunoVM.studentsLoad()
            await alunoVM.groupLoad()
        }
        .sheet(isPresented: $alunoVM.criarGrupo) {
            CriarGrupoView(onGrupoCriado: {
                Task { await alunoVM.groupLoad() }
            })
        }
    }
    
    // MARK: - Empty State
    private func emptyStateView(image: String, title: String, subtitle: String) -> some View {
        VStack {
            Spacer(minLength: 100)
            
            ZStack {
                Image(systemName: image)
                    .foregroundColor(Color(.accent))
                
                Circle()
                    .fill(Color(.accent))
                    .opacity(0.3)
                    .frame(width: 50, height: 50)
                    .padding()
            }
            
            VStack(spacing: -15) {
                Text(title)
                    .font(.title3)
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
                    .padding()
                
                Text(subtitle)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
            }
            Spacer()
        }
    }
    
}



#Preview {
    let services = PersistenceServices.shared
    let viewModel = AlunosViewModel(persistenceServices: services)
    
    AlunosView(alunoVM: viewModel) {_ in
        
    }
    .environmentObject(services)
}
