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
        VStack(spacing: -15) {
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
        .navigationTitle("Alunos")
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    onNavigate(.solicitation)
                } label: {
                    Image(systemName: "person.fill.checkmark.and.xmark")
                        .foregroundStyle(Color(.accent))
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button { alunoVM.criarGrupo = true } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color(.accent))
                }
            }
        }
        .task {
            await alunoVM.groupLoad()
        }
        .sheet(isPresented: $alunoVM.criarGrupo) {
            CriarGrupoView(onGrupoCriado: {
                Task { await alunoVM.groupLoad() }
            })
        }
        .onAppear {
            alunoVM.selectedMode = .Grupos
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
