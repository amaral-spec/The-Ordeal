import SwiftUI

struct ResumeStudentView: View {
    
    @EnvironmentObject var resumeVM: ResumeViewModel
    let onNavigate: (ResumeCoordinatorView.Route) -> Void
    
    var body: some View {
        VStack(spacing: 20) {

            // MARK: Streak Card
            StreakCardView()
                .padding(.horizontal)

            // MARK: Main Challenge
            ChallengeCardView()
                .padding(.horizontal)

            // MARK: Grid Tarefas + Treino
            HStack(spacing: 20) {
                TaskCardView()
                TrainingCardView()
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding(.top, 12)
//        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle("Resumo")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
           
        }

    }
    
}
