import SwiftUI

struct ResumeStudentView: View {
    
    @EnvironmentObject var resumeVM: ResumeViewModel
    let onNavigate: (ResumeCoordinatorView.Route) -> Void
    
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
                TrainingCardView()
            }
            Spacer()
        }
        .padding(.top, 12)
        .padding(.horizontal, 16)
        .navigationTitle("Resumo")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
           
        }

    }
    
}
