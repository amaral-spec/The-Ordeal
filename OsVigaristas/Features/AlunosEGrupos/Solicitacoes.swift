import SwiftUI
import CloudKit


struct Solicitacoes: View {
    @EnvironmentObject var persistenceServices: PersistenceServices
    @State private var solicitacoes: [CKRecord.ID : [UserModel]] = [:]
    @State private var groupsByID: [CKRecord.ID: GroupModel] = [:] // optional cache
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(solicitacoes.keys.sorted(), id: \.self) { groupID in
                    if let group = groupsByID[groupID] {
                        Section(header: Text(group.name)) {
                            ForEach(solicitacoes[groupID] ?? []) { student in
                                HStack {
                                    Text(student.name)
                                    Spacer()
                                    Button("Aceitar") {
                                        Task {
                                            do {
                                                try await persistenceServices.addStudent(student, to: group)
                                                // Remove from local list
                                                //removeStudent(student, from: groupID)
                                            } catch {
                                                print("Erro ao aceitar aluno: \(error)")
                                            }
                                        }
                                    }
                                    Button("Rejeitar") {
                                        Task {
                                            do {
                                                try await persistenceServices.rejectStudent(student, from: group)
                                                //removeStudent(student, from: groupID)
                                            } catch {
                                                print("Erro ao rejeitar aluno: \(error)")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Solicitações")
            .task {
                do {
                    solicitacoes = try await persistenceServices.fetchSolicitations()
                    // Optionally fetch group names
                    let groups = try await persistenceServices.fetchAllGroups()
                    groupsByID = Dictionary(uniqueKeysWithValues: groups.map { ($0.id, $0) })
                } catch {
                    print("Solicitações não carregadas: \(error)")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
