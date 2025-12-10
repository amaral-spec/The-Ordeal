import SwiftUI

struct MeusGrupos: View {
    @EnvironmentObject var perfilVM: PerfilViewModel
    @EnvironmentObject var persistenceService: PersistenceServices
    @EnvironmentObject var authService: AuthService
    
    // 1. Estados para controlar qual grupo será deletado e mostrar o alerta
    @State private var groupToDelete: GroupModel?
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        // 2. Trocamos ScrollView por List para habilitar o swipeActions
        List {
            if perfilVM.isLoadingGroups {
                // Colocamos numa Section para centralizar o loading na lista
                Section {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
            }
            else if perfilVM.fetchedAllGroups.isEmpty {
                // Empty State
                Section {
                    EmptyStateMyGroupsView()
                }
                .listRowBackground(Color.clear)
            }
            else {
                ForEach(perfilVM.fetchedAllGroups) { grupo in
                    GroupCard(grupo: grupo)
                        // 3. Ajustes visuais para a List parecer um ScrollView com Cards
                        .listRowSeparator(.hidden) // Remove linha cinza
                        .listRowBackground(Color.clear) // Remove fundo branco padrão da célula
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)) // Dá espaçamento entre os cards
                        
                        // 4. O SWIPE: Ação de deslizar
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                // Armazena o grupo clicado e abre o alerta
                                groupToDelete = grupo
                                showDeleteAlert = true
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                }
            }
        }
        .listStyle(.plain) // Remove o estilo agrupado padrão do iOS
        .scrollContentBackground(.hidden) // Garante que o fundo da lista seja transparente
        .background(Color(.secondarySystemBackground)) // Aplica sua cor de fundo original
        .navigationTitle("Meus grupos")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            await perfilVM.fetchAllGroups()
        }
        .task {
            await perfilVM.fetchAllGroups()
        }
        // 5. O ALERTA: Confirmação de exclusão
        .alert("Excluir Grupo?", isPresented: $showDeleteAlert, presenting: groupToDelete) { grupo in
            Button("Cancelar", role: .cancel) {
                groupToDelete = nil
            }
            
            Button("Excluir", role: .destructive) {
                Task {
                    await performDelete(grupo)
                }
            }
        } message: { grupo in
            Text("Você tem certeza que deseja excluir o grupo '\(grupo.name)'? Essa ação não pode ser desfeita.")
        }
    }
    
    // 6. Lógica de Deleção
    func performDelete(_ grupo: GroupModel) async {
        do {
            
            try await persistenceService.removeMember(from: grupo, usuario: authService.currentUser!)
            
            print("Deletando grupo: \(grupo.name)") // Placeholder
            
            // Atualiza a lista após deletar
            await MainActor.run {
                // Opcional: Remover da lista local imediatamente para feedback visual rápido
                if let index = perfilVM.fetchedAllGroups.firstIndex(where: { $0.id == grupo.id }) {
                    perfilVM.fetchedAllGroups.remove(at: index)
                }
            }
            

            await perfilVM.fetchAllGroups()
            
        } catch {
            print("Erro ao deletar grupo: \(error)")
        }
    }
}
