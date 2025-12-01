import Foundation
import SwiftUI

struct ResumeTeacherView: View {
    
    @State private var criarDesafio = false
    @State private var criarTarefa = false

    @EnvironmentObject var resumeVM: ResumeViewModel
    let onNavigate: (ResumeCoordinatorView.Route) -> Void
    
    enum Mode: String, CaseIterable {
        case Desafio, Tarefa
    }
    
    @State private var selectedMode: Mode = .Desafio
    
    var body: some View {
        ScrollView() {
            ChallengeCardView(resumoVM: resumeVM)
                .padding(.horizontal)
                .padding(.top)
                .onTapGesture {
                    if resumeVM.challenges.isEmpty {
                        criarDesafio = true
                    } else {
                        onNavigate(.listChallenge)
                    }
                }
                .padding(.bottom, 15)
            
            BigTaskCardView(resumoVM: resumeVM)
                .padding(.horizontal)
                .onTapGesture {
                    if resumeVM.tasks.isEmpty {
                        criarTarefa = true
                    } else {
                        onNavigate(.listTask)
                    }
                }
            

            Spacer()
        }
        .background(Color(.secondarySystemBackground))
        .navigationTitle("Início")
        .toolbarTitleDisplayMode(.inlineLarge)
        .task {
            await resumeVM.carregarDesafios()
            await resumeVM.carregarTarefas()
        }
        // MARK: - Pull-to-refresh
        .refreshable {
            await resumeVM.carregarDesafios()
            await resumeVM.carregarTarefas()
        }
        
        
        // MARK: - Sheets
        .sheet(isPresented: $criarDesafio) {
            CriarDesafioView(numChallenge: .constant(0))
        }
        .sheet(isPresented: $criarTarefa) {
            CriarTarefaView(numTask: .constant(0))
        }
    }
    
}

