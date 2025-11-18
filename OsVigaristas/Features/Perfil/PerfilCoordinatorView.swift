import SwiftUI
import CloudKit


struct PerfilCoordinatorView: View {
    @EnvironmentObject var authVM: AuthViewModel
    let isProfessor: Bool
    @State private var groupCode: String = ""
    @EnvironmentObject var persistenceServices: PersistenceServices
    
    @State private var fetchedGroup: GroupModel? = nil
    @State private var fetchError: String? = nil

    var body: some View {
        if isProfessor {
            Text("Perfil Professor")
            Button("Logout") { authVM.logout() }

        } else {
            VStack {
                TextField("Código do grupo", text: $groupCode)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                if let group = fetchedGroup {
                    Text("Grupo encontrado: \(group.name)")
                        .foregroundColor(.green)
                } else if let error = fetchError {
                    Text("Erro: \(error)")
                        .foregroundColor(.red)
                } else {
                    Text("Nenhum grupo encontrado")
                        .foregroundColor(.gray)
                }

                Button("Logout") { authVM.logout() }
            }
            .onChange(of: groupCode) { newValue in
                Task {
                    do {
                        fetchedGroup = try await persistenceServices.fetchGroupByCode(code: newValue)
                        fetchError = nil
                    } catch {
                        fetchedGroup = nil
                        fetchError = error.localizedDescription
                    }
                }
            }
        }
    }
}
