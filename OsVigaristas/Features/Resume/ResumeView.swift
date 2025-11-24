import SwiftUI

struct ResumeView: View {

    enum Mode: String, CaseIterable {
        case Desafio, Tarefa
    }
    
    
    @Environment(\.selectedStudentTab) var selectedTab
    
    @State private var criarDesafio = false
    @State private var criarTarefa = false
    @State private var desafios: [ChallengeModel] = []
    @State private var isChallengeEmpty: Bool = true
    @State private var selectedMode = Mode.Desafio

    @StateObject var resumeVM: ResumeViewModel
    
    let onNavigate: (ResumeCoordinatorView.Route) -> Void
    
    var body: some View {
        Picker("", selection: $selectedMode) {
            ForEach(Mode.allCases, id: \.self) { mode in
                Text(mode.rawValue)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        
        VStack {
            if selectedMode == .Desafio {
                desafiosSection
            } else {
                tarefasSection
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle("Resumo")
        .task {
            await resumeVM.carregarDesafios()
            await resumeVM.carregarTarefas()
        }
        .refreshable {
            if (selectedMode == .Desafio) {
                await resumeVM.carregarDesafios()
            } else {
                await resumeVM.carregarTarefas()
            }
        }
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            if (resumeVM.isTeacher) {
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
            } else {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        selectedTab?.wrappedValue = .perfil
                    } label: {
                            (Text("40").foregroundStyle(.black) + Text(Image(systemName: "bitcoinsign.circle.fill")))
                            +
                            (Text("  4").foregroundStyle(.black) + Text(Image(systemName: "flame.fill")))
                        }
                }
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
    
    private var desafiosSection: some View {
        Group {
            if resumeVM.challenges.count == 0 {
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
            if resumeVM.tasks.count == 0 {
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

#Preview {
    // Preview simples: NavigationStack opcional, sem navegação de destino.
    let services = PersistenceServices()
    let vm = ResumeViewModel(persistenceServices: services, isTeacher: true)
    
    NavigationStack {
        ResumeView(resumeVM: vm) { _ in
            // onNavigate vazio no preview
        }
        .navigationTitle("Resumo")
        .toolbarTitleDisplayMode(.inlineLarge)
    }
}
