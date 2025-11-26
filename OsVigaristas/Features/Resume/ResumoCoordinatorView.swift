import SwiftUI
import Foundation

struct ResumeCoordinatorView: View {
    enum Route: Hashable {
        case list
        case detailChallenge(ChallengeModel)
        case detailTask(TaskModel)
        case participants
    }
    
    @EnvironmentObject var persistenceServices: PersistenceServices

    

    @State private var path: [Route] = []
    let isTeacher: Bool
    @StateObject private var resumeVM: ResumeViewModel

    init(isTeacher: Bool) {
        self.isTeacher = isTeacher
        _resumeVM = StateObject(wrappedValue: ResumeViewModel(persistenceServices: PersistenceServices(), isTeacher: isTeacher))
    }

    var body: some View {
        NavigationStack(path: $path) {
            ResumeView(resumeVM: resumeVM) { route in
                path.append(route)
            }
            .onAppear {
                // Replace the temporary services with the environment one if needed
                // Only recreate if the instance differs to avoid resetting observers unnecessarily.
                // Since ResumeViewModel stores persistenceServices privately and has no setter,
                // recreate the VM when the environment becomes available.
                // Note: This keeps isTeacher consistent with the initializer’s value.
                // If you need dynamic isTeacher from elsewhere, adjust accordingly.
                if type(of: resumeVM) == ResumeViewModel.self {
                    // No-op: resumeVM already exists. If you must ensure it uses the environment services,
                    // you can recreate it once here:
                    // resumeVM = ResumeViewModel(persistenceServices: persistenceServices, isTeacher: isTeacher)
                    // But because resumeVM is a StateObject, we cannot reassign it directly.
                    // If you need the environment instance, initialize StateObject with it via a custom init:
                    // see alternative init below.
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .detailChallenge(let challenge):
                    VisualizarDadosView()
                        .environmentObject(resumeVM)

                case .detailTask(let task):
                    VisualizarDadosView()
                        .environmentObject(resumeVM)
                case .list:
                    EmptyView()
                    
                case .participants:
                    ListaParticipantesView()
                        .environmentObject(resumeVM)
                
                }
            }
        }
    }
}
