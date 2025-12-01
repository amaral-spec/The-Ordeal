import SwiftUI

struct ResumeStudentView: View {
    
    @EnvironmentObject var resumeVM: ResumeViewModel
    let onNavigate: (ResumeCoordinatorView.Route) -> Void
    
    var body: some View {
        VStack() {

            // MARK: Streak Card
            StreakCardView()
            

            // MARK: Main Challenge
            Button {
                onNavigate(.listChallenge)
            } label: {
                ChallengeCardView(resumoVM: resumeVM)
            }

            // MARK: Grid Tarefas + Treino
            HStack() {
                Button {
                    onNavigate(.listTask)
                } label: {
                    TaskCardView(resumoVM: resumeVM)
                }
                TrainingCardView()
                    .padding(.trailing, 12)
            }
            Spacer()
        }
        .padding(.top, 12)
        .background(Color(.secondarySystemBackground).ignoresSafeArea())
        .navigationTitle("Resumo")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
           
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
