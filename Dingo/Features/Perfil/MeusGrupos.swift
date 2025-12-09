import SwiftUI

struct MeusGrupos: View {
    // Substituímos o EnvironmentObject pelo StateObject específico desta tela
    @EnvironmentObject var perfilVM: PerfilViewModel
    
    var body: some View {
        ScrollView {
            if perfilVM.isLoadingGroups {
                ProgressView()
            }
            else if perfilVM.fetchedAllGroups.isEmpty {
                // Exibe a tela de vazio se não houver grupos
                EmptyStateMyGroupsView()
            }
            else {
                // Exibe a lista se houver grupos
                 
                    VStack(spacing: 16) {
                        ForEach(perfilVM.fetchedAllGroups) { grupo in
                            GroupCard(grupo: grupo)
                        }
                    }
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
        .navigationTitle("Meus grupos")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            await perfilVM.fetchAllGroups()
        }
        .task {
            await perfilVM.fetchAllGroups()
        }
    }
}
