import SwiftUI
import CloudKit


struct PerfilCoordinatorView: View {
    enum Route: Hashable {
        case meusGrupos
    }
    
    @EnvironmentObject var persistenceServices: PersistenceServices
    let isTeacher: Bool
    @State private var path: [Route] = []
    @StateObject private var perfilVM: PerfilViewModel
    
    init(isTeacher: Bool) {
        _perfilVM = StateObject(wrappedValue: PerfilViewModel(persistenceServices: PersistenceServices()))
        self.isTeacher = isTeacher
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(){
                if isTeacher {
                    PerfilProfessorView()
                        .environmentObject(perfilVM)
                    
                } else {
                    PerfilStudentView() { next in
                        path.append(next)
                    }
                    .environmentObject(perfilVM)

                }
            }
            .navigationDestination(for: Route.self){ route in
                switch route {
                    case .meusGrupos:
                        MeusGrupos()
                        .environmentObject(perfilVM)
                }
            }
        }
    }
}
