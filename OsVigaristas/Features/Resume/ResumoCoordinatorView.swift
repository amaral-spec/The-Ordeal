
import SwiftUI
import Foundation

struct ResumeCoordinatorView: View {
    
    enum Route: Hashable {
        case list
        case detailChallenge(ChallengeModel)
        case detailTask(TaskModel)
    }

    @State private var path: [Route] = []
    let isTeacher: Bool

    var body: some View {
        NavigationStack(path: $path) {
            ResumeView(resumeVM: ResumeViewModel(isTeacher: isTeacher)) { route in
                path.append(route)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .detailChallenge(let challenge):
//                    ChallengeDetailView(challenge: challenge)
                    DetalhesTarefasView()
//                    EmptyView()

                case .detailTask(let task):
                    DetalhesTarefasView()
//                    TaskDetailView(task: task)
//                    EmptyView()EmptyView()

                case .list:
                    EmptyView()
                }
            }
        }
    }
}
