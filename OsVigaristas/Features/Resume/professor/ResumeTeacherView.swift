
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
        VStack(spacing: 0) {
            
            // MARK: Picker
            Picker("", selection: $selectedMode) {
                ForEach(Mode.allCases, id: \.self) { mode in
                    Text(mode.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            // MARK: Conteúdo
            VStack {
                if selectedMode == .Desafio {
                    desafiosSection
                } else {
                    tarefasSection
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .background(Color(.secondarySystemBackground))
        .navigationTitle("Resumo")
        .toolbarTitleDisplayMode(.inlineLarge)
        
        
        // MARK: - Toolbar do Professor
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    if selectedMode == .Desafio {
                        criarDesafio = true
                    } else {
                        criarTarefa = true
                    }
                } label: {
                    Label("Adicionar", systemImage: "plus")
                }
            }
        }
        
        
        .task {
            await resumeVM.carregarDesafios()
            await resumeVM.carregarTarefas()
        }
        
        
        // MARK: - Pull-to-refresh
        .refreshable {
            if selectedMode == .Desafio {
                await resumeVM.carregarDesafios()
            } else {
                await resumeVM.carregarTarefas()
            }
        }
        
        
        // MARK: - Sheets
        .sheet(isPresented: $criarDesafio) {
            CriarDesafioView(numChallenge: .constant(0))
        }
        .sheet(isPresented: $criarTarefa) {
            CriarTarefaView(numTask: .constant(0))
        }
    }
    
    // MARK: - DESAFIOS
    private var desafiosSection: some View {
        Group {
            if resumeVM.challenges.isEmpty {
                EmptyStateView(
                    icon: "flag.pattern.checkered.2.crossed",
                    title: "Sem Desafios",
                    message: "Você não possui nenhum desafio"
                )
            } else {
                ListChallenge(
                    challengeList: resumeVM.challenges,
                    onTap: { onNavigate(.detailChallenge($0)) }
                )
                .environmentObject(resumeVM)
            }
        }
    }
    
    // MARK: - TAREFAS
    private var tarefasSection: some View {
        Group {
            if resumeVM.tasks.isEmpty {
                EmptyStateView(
                    icon: "checklist.checked",
                    title: "Sem Tarefas",
                    message: "Você não possui nenhuma tarefa"
                )
            } else {
                ListTask(
                    taskList: resumeVM.tasks,
                    onTap: { onNavigate(.detailTask($0)) }
                )
                .environmentObject(resumeVM)
            }
        }
    }
}

