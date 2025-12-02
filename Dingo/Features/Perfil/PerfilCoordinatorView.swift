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
            PerfilProfessorView(persistenceServices: persistenceServices)

        } else {
            PerfilStudentView(persistenceServices: persistenceServices)
//            AlunoPerfilView(viewModel: PerfilViewModel(userType: .aluno))

        }
    }
}
