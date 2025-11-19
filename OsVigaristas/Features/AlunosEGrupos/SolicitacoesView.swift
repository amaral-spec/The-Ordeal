import SwiftUI
import CloudKit

struct SolicitacoesView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var persistenceServices: PersistenceServices
    @ObservedObject var alunoVM: AlunosViewModel
    
    @State private var solicitantes: [CKRecord.ID: [UserModel]] = [:]
    @State private var group: GroupModel?
    
    var body: some View {
        List {
            ForEach(Array(solicitantes.values).flatMap { $0 }) { user in
                SolicitacaoCard(
                    user: user,
                    groupName: group?.name ?? "",
                    onAccept: {
                        Task {
                            guard let group = group else {
                                print("Não foi possível aceitar: group é nil")
                                return
                            }
                            do {
                                try await persistenceServices.acceptSolicitation(to: group, usuario: user)
                                
                                await alunoVM.loadSolicitations()
                                
                                await MainActor.run {
                                    self.solicitantes = alunoVM.solicitations
                                }
                            } catch {
                                print("Erro ao aceitar solicitação:", error)
                            }
                        }
                    },
                    onReject: {
                        Task {
                            guard let group = group else {
                                print("Não foi possível rejeitar: group é nil")
                                return
                            }
                            do {
                                try await persistenceServices.rejectSolicitation(to: group, usuario: user)
                                
                                await alunoVM.loadSolicitations()
                                
                                await MainActor.run {
                                    self.solicitantes = alunoVM.solicitations
                                }
                            } catch {
                                print("Erro ao rejeitar solicitação:", error)
                            }
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
            /// Carrega as solicitações
            await alunoVM.loadSolicitations()
            self.solicitantes = alunoVM.solicitations
            
            /// Agora buscamos o grupo correspondente
            if let groupID = alunoVM.solicitations.keys.first {
                do {
                    let fetchedGroup = try await persistenceServices.fetchGroup(recordID: groupID)
                    await MainActor.run {
                        self.group = fetchedGroup
                    }
                } catch {
                    print("Erro ao buscar o grupo:", error)
                }
            } else {
                self.group = nil
            }
        }
    }
}
