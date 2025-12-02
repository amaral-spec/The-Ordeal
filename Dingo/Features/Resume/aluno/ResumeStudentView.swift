import SwiftUI

struct ResumeStudentView: View, CardNavigationHandler {

    @EnvironmentObject var resumeVM: ResumeViewModel
    let onNavigate: (ResumeCoordinatorView.Route) -> Void

    // MARK: - Navegação do protocolo
    func navigateToChallengeList() {
        onNavigate(.listChallenge)
    }

    func navigateToTaskList() {
        onNavigate(.listTask)
    }

    var body: some View {
        ScrollView() {
            // MARK: Streak Card
            StreakCardView()
                .padding(.horizontal)
          
            // MARK: Challenge Card (Aluno)
            BigChallengeCardView(
                resumoVM: resumeVM,
                navigationHandler: self
            )
            .padding(.all)

            // MARK: Grid: Tarefas + Treino
            HStack(spacing: 16) {
                BigTaskCardView(
                    resumoVM: resumeVM,
                    navigationHandler: self
                )
                TrainingCardView()
//                    .padding(.leading)
                    
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 12)
        .background(Color(.secondarySystemBackground).ignoresSafeArea())
        .navigationTitle("Resumo")
        .toolbarTitleDisplayMode(.inlineLarge)
        .task {
            async let desafios: () = resumeVM.carregarDesafios()
            async let tarefas: () = resumeVM.carregarTarefas()
            _ = await (desafios, tarefas)
        }
        .refreshable {
            async let desafios: () = resumeVM.carregarDesafios()
            async let tarefas: () = resumeVM.carregarTarefas()
            _ = await (desafios, tarefas)
        }
    }
}

#Preview {
    ResumeStudentView { _ in }
        .environmentObject(
            ResumeViewModel(
                persistenceServices: PersistenceServices(),
                isTeacher: false
            )
        )
}
