import SwiftUI
import CloudKit

struct SolicitacoesView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var persistenceServices: PersistenceServices
    
    @State private var solicitantes: [UserModel] = []
    @State private var group: GroupModel?
    
    var body: some View {
        List {
            ForEach(solicitantes) { user in
                SolicitacaoCard(
                    user: user,
                    groupName: group?.name ?? "",
                    onAccept: {
                        Task {
                            try? await persistenceServices.acceptSolicitation(to: group!, usuario: user)
                        }
                    },
                    onReject: {
                        Task {
                            try? await persistenceServices.rejectSolicitation(to: group!, usuario: user)
                        }
                    }
                )
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Solicitações")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.black)
                }
            }
        }
        .task {
            do {
                try await persistenceServices.fetchSolicitations()
            } catch {
                print("Erro ao carregar solicitações: \(error)")
            }
        }
        
    }
}
