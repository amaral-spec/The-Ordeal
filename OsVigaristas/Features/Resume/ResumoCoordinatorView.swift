
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
//                    ChallengeDetailView(challenge: challenge)
                    TaskDetailView()
                        .environmentObject(resumeVM)
//                    EmptyView()

                case .detailTask(let task):
                    TaskDetailView()
                        .environmentObject(resumeVM)
//                    TaskDetailView(task: task)
//                    EmptyView()EmptyView()

                case .list:
                    EmptyView()
                    
                case .participants:
                    ListaParticipantesView(resumeVM: ResumeViewModel())
                    
                
                }
            }
        }
    }
}
