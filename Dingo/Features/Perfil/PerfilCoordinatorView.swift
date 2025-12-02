import SwiftUI
import CloudKit


struct PerfilCoordinatorView: View {
    enum Route: Hashable {
        case perfilProfessor
        case perfilAluno
        case meusGrupos
    }
    
    @EnvironmentObject var persistenceServices: PersistenceServices
    
    @StateObject private var authVM: AuthViewModel
    let isTeacher: Bool
    @State private var path: [Route] = []
    
    init(isTeacher: Bool) {
        self.isTeacher = isTeacher
        _authVM = StateObject(wrappedValue: AuthViewModel(authService: <#AuthService#>))
    }
    
    @State private var groupCode: String = ""
    
    @State private var fetchedGroup: GroupModel? = nil
    @State private var fetchError: String? = nil

    
    
    
    var body: some View {
        
        if isTeacher {
            PerfilProfessorView(persistenceServices: persistenceServices)

        } else {

            PerfilView(persistenceServices: persistenceServices)


        }
        
    }
}
