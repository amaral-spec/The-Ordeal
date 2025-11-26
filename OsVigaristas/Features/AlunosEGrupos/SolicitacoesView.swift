import SwiftUI
import CloudKit

struct SolicitacoesView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var persistenceServices: PersistenceServices
    @ObservedObject var alunoVM: AlunosViewModel
    
    @State private var solicitantes: [CKRecord.ID: [UserModel]] = [:]
    @State private var group: GroupModel?
    @State private var failMessage: Bool = false
    @State private var acceptNotification: Bool = false
    @State private var rejectNotification: Bool = false
    
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
                                    
                                    withAnimation {
                                        acceptNotification = true
                                    }
                                    
                                    // Removes feedback after 2.0 seconds
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        withAnimation {
                                            self.acceptNotification = false
                                        }
                                    }
                                    
                                    // Haptics
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            } catch {
                                print("Erro ao aceitar solicitação:", error)
                                
                                withAnimation {
                                    failMessage = true
                                }
                                
                                // Removes feedback after 2.0 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation {
                                        self.failMessage = false
                                    }
                                }
                                
                                // Haptics
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
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
                                    
                                    withAnimation {
                                        rejectNotification = true
                                    }
                                    
                                    // Removes feedback after 2.0 seconds
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        withAnimation {
                                            self.rejectNotification = false
                                        }
                                    }
                                    
                                    // Haptics
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                    
                                }
                            } catch {
                                print("Erro ao rejeitar solicitação:", error)
                                
                                withAnimation {
                                    failMessage = true
                                }
                                
                                // Removes feedback after 2.0 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation {
                                        self.failMessage = false
                                    }
                                }
                                
                                // Haptics
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
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
        .overlay(alignment: .top) {
            if acceptNotification {
                Text("Solicitação aceita!")
                    .font(.headline)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color("BlueCard"))
                    .cornerRadius(30)
                    .padding(.top, 40)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(duration: 0.4), value: acceptNotification)
            } else if rejectNotification {
                Text("Solicitação recusada!")
                    .font(.headline)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color("RedCard"))
                    .cornerRadius(30)
                    .padding(.top, 40)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(duration: 0.4), value: rejectNotification)
            } else if failMessage {
                Text("Erro ao realizar operação")
                    .font(.headline)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color("RedCard"))
                    .cornerRadius(30)
                    .padding(.top, 40)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(duration: 0.4), value: failMessage)
            }
        }
    }
}
