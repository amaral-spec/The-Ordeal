import SwiftUI

struct ResumeStudentView: View, CardNavigationHandler {
    
    @EnvironmentObject var streakVM: StreakViewModel
    @EnvironmentObject var resumeVM: ResumeViewModel
    let onNavigate: (ResumeCoordinatorView.Route) -> Void
    @State var startTraining: Bool = false
    
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
                .padding(.horizontal, 8)
            
            // MARK: Challenge Card (Aluno)
            BigChallengeCardView(
                resumoVM: resumeVM,
                navigationHandler: self
            )
            .shadow(color: .black.opacity(0.1), radius: 2, y: 2)
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            
            // MARK: Grid: Tarefas + Treino
            HStack(spacing: 16) {
                BigTaskCardView(
                    resumoVM: resumeVM,
                    navigationHandler: self
                )
                .shadow(color: .black.opacity(0.1), radius: 2, y: 2)
                
                TrainingCardView()
                    .onTapGesture {
                        startTraining = true
                    }
                    .shadow(color: .black.opacity(0.1), radius: 2, y: 2)
                
            }
            .padding(.horizontal, 8)
            
            Spacer()
        }
        .padding(.top, 12)
        .background(Color(.secondarySystemBackground).ignoresSafeArea())
        .navigationTitle("Resumo")
        .toolbarTitleDisplayMode(.inlineLarge)
        .sheet(isPresented: $startTraining) {
            TrainingCoordinatorView()
                .interactiveDismissDisabled(true)//Tira o deslizar para sair
        }
        .task {
            async let desafios: () = resumeVM.carregarDesafios()
            async let tarefas: () = resumeVM.carregarTarefas()
            _ = await (desafios, tarefas)
        }
        .refreshable {
            await streakVM.loadStreak()
            await streakVM.updateTrainingDates()
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
