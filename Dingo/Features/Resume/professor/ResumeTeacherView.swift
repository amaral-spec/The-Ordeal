import SwiftUI

struct ResumeTeacherView: View, CardNavigationHandler {

    @EnvironmentObject var resumeVM: ResumeViewModel
    let onNavigate: (ResumeCoordinatorView.Route) -> Void

    // MARK: - Navigation Handler (protocol)
    func navigateToChallengeList() {
        onNavigate(.listChallenge)
    }

    func navigateToTaskList() {
        onNavigate(.listTask)
    }

    var body: some View {
        ScrollView {
            
            BigChallengeCardView(
                resumoVM: resumeVM,
                navigationHandler: self
            )
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, 15)

            BigTaskCardView(
                resumoVM: resumeVM,
                navigationHandler: self
            )
            .padding(.horizontal)

            Spacer()
        }
        .background(Color(.secondarySystemBackground))
        .navigationTitle("Início")
        .toolbarTitleDisplayMode(.inlineLarge)
        
        // Carrega tudo ao abrir
        .task {
            await resumeVM.carregarDesafios()
            await resumeVM.carregarTarefas()
        }
        
        // Pull to refresh
        .refreshable {
            await resumeVM.carregarDesafios()
            await resumeVM.carregarTarefas()
        }
    }
}
