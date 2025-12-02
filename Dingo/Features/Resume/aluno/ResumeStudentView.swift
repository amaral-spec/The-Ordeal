import SwiftUI

struct ResumeStudentView: View {
    
    @EnvironmentObject var resumeVM: ResumeViewModel
    let onNavigate: (ResumeCoordinatorView.Route) -> Void
    @State var startTraining: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            
            // MARK: Streak Card
            StreakCardView()
            
            // MARK: Main Challenge
            Button {
                onNavigate(.listChallenge)
            } label: {
                ChallengeCardView(resumoVM: resumeVM)
            }
            
            // MARK: Grid Tarefas + Treino
            HStack(spacing: 12) {
                Button {
                    onNavigate(.listTask)
                } label: {
                    TaskCardView(resumoVM: resumeVM)
                }
                
                
                //Button of training
                Button{
                    //StartTrainingView()
                    startTraining = true
                } label: {
                    TrainingCardView()
                    
                }
            }
            Spacer()
        }
        .padding(.top, 12)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground).ignoresSafeArea())
        .navigationTitle("Resumo")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            
        }
        
        .sheet(isPresented: $startTraining) {
            TrainingCoordinatorView()
                .interactiveDismissDisabled(true)//Tira o deslizar para sair
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
