import SwiftUI

struct ResumeStudentView: View {
    
    @EnvironmentObject var resumeVM: ResumeViewModel
    let onNavigate: (ResumeCoordinatorView.Route) -> Void
    
    var body: some View {
        ScrollView() {
            // MARK: Streak Card
            StreakCardView()

            // MARK: Main Challenge
            ChallengeCardView(resumoVM: resumeVM)
                .padding(.horizontal)
                .onTapGesture {
                    if resumeVM.challenges.isEmpty {
                        onNavigate(.listChallenge)
                    }
                }
            
            // MARK: Grid Tarefas + Treino
            HStack(spacing: 16) {
                TaskCardView(resumoVM: resumeVM)
                    .onTapGesture {
                        if resumeVM.tasks.isEmpty {
                            onNavigate(.listTask)
                        }
                    }
                    
                
                TrainingCardView()
//                    .padding(.leading)
                    
            }
            .padding(.horizontal)
            
        }
        .refreshable {
            Void()
        }
        .background(Color(.secondarySystemBackground))
        .navigationTitle("Resumo")
        .toolbarTitleDisplayMode(.inlineLarge)
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
