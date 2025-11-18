
import SwiftUI
import Foundation

struct ResumeCoordinatorView: View {
    
    enum Route: Hashable {
        case list
        case detailChallenge(ChallengeModel)
        case detailTask(TaskModel)
        case participants
    }

    @State private var path: [Route] = []
    let isTeacher: Bool
    var resumeVM: ResumeViewModel
    
    init(isTeacher: Bool) {
        self.isTeacher = isTeacher
        resumeVM = ResumeViewModel(isTeacher: isTeacher)
    }

    var body: some View {
        NavigationStack(path: $path) {
            ResumeView(resumeVM: resumeVM) { route in
                path.append(route)
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
