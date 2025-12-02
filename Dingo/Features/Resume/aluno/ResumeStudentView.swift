import SwiftUI

struct ResumeStudentView: View, CardNavigationHandler {

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
                .padding(.horizontal)
          
            // MARK: Challenge Card (Aluno)
            BigChallengeCardView(
                resumoVM: resumeVM,
                navigationHandler: self
            )
            .padding(.horizontal)

            // MARK: Grid: Tarefas + Treino
            HStack(spacing: 16) {
                BigTaskCardView(
                    resumoVM: resumeVM,
                    navigationHandler: self
                )
                //Button of training
                Button{
                    //StartTrainingView()
                    startTraining = true
                } label: {
                    TrainingCardView()
                    
                }
//                    .padding(.leading)
                    
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 12)
        .background(Color(.secondarySystemBackground).ignoresSafeArea())
        .navigationTitle("Resumo")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            
        }
        
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
