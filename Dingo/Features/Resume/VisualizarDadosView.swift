//
//  VisualizarDadosView.swift
//  OsVigaristas
//

import SwiftUI
import CloudKit

struct VisualizarDadosView: View {
    
    // MARK: - Properties
    
    // Configurações de Entrada
    let isChallenge: Bool
    let challengeModel: ChallengeModel?
    let taskModel: TaskModel?
    let onNavigate: (ResumeCoordinatorView.Route) -> Void
    
    // Environment
    @EnvironmentObject var resumeVM: ResumeViewModel
    
    // State Objects
    @StateObject var doChallengeVM = DoChallengeViewModel(
        persistenceServices: PersistenceServices()
    )
    
    // Local States
    @State private var alreadyDone: Bool = false
    @State private var selectedMember: UserModel?
    @State private var startChallenge: Bool = false
    @State private var isLoading: Bool = true
    @State private var isCheckingStatus: Bool = true
    
    // MARK: - Init
    
    init(isChallenge: Bool,
         challengeModel: ChallengeModel? = nil,
         taskModel: TaskModel? = nil,
         onNavigate: @escaping (ResumeCoordinatorView.Route) -> Void) {
        self.isChallenge = isChallenge
        self.challengeModel = challengeModel
        self.taskModel = taskModel
        self.onNavigate = onNavigate
    }
    
    // MARK: - Computed Properties (Helpers)
    
    private var themeColor: Color {
        isChallenge ? Color("BlueCard") : Color("GreenCard")
    }
    
    private var title: String {
        isChallenge ? (challengeModel?.title ?? "") : (taskModel?.title ?? "")
    }
    
    private var description: String {
        isChallenge ? (challengeModel?.description ?? "") : (taskModel?.description ?? "")
    }
    
    private var endDate: Date {
        isChallenge ? (challengeModel?.endDate ?? Date()) : (taskModel?.endDate ?? Date())
    }
    
    private var isListEmpty: Bool {
        if isChallenge { return resumeVM.members.isEmpty }
        else { return resumeVM.alunosTarefas.isEmpty }
    }
    
    private var challengeTypeName: String {
        guard let type = challengeModel?.whichChallenge else { return "" }
        switch type {
        case 1: return "Ecco"
        case 2: return "Encadeia"
        default: return "Desconhecido"
        }
    }
    
    private var challengeTypeIcon: String {
        guard let type = challengeModel?.whichChallenge else { return "questionmark" }
        switch type {
        case 1: return "waveform"
        case 2: return "link"
        default: return "circle"
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                timeCard
                descriptionCard
                participantsCard
                if isChallenge && !resumeVM.isTeacher {
                    if isCheckingStatus {
                        loadingButton // <--- Mostra o loading enquanto checa
                    } else if !alreadyDone {
                        startButton
                    } else {
                        alreadyDoneChallenge
                    }
                }
            }
            .padding(20)
        }
        .background(Color(.secondarySystemBackground))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        
        // MARK: Sheets
        .sheet(item: $selectedMember) { member in
            DetailEachAluno(member: member)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $startChallenge) {
            if let challenge = challengeModel {
                DoChallengeCoordinatorView(challengeM: challenge)
                    .interactiveDismissDisabled(true)
            }
        }
        
        // MARK: Async Tasks
        .task {
            await loadData()
        }
    }
    
    // MARK: - Logic Methods
    
    private func loadData() async {
            self.isLoading = true
            // defer { self.isLoading = false } // <--- REMOVA O DEFER DAQUI
            
            // 1. Carrega participantes e libera a tela principal
            if isChallenge, let challenge = challengeModel {
                await resumeVM.carregarParticipantesPorDesafio(challenge: challenge)
                self.isLoading = false // <--- LIBERA A UI PRINCIPAL AQUI
                
                // 2. Verifica se aluno já fez (Botão entra em loading específico)
                if !resumeVM.isTeacher {
                    withAnimation { self.isCheckingStatus = true } // Ativa loading do botão
                    
                    let done = await doChallengeVM.isHeAlreadyDoneThisChallenge(challengeID: challenge.id)
                    
                    withAnimation {
                        self.alreadyDone = done
                        self.isCheckingStatus = false // Desativa loading do botão
                    }
                }
                
            } else if let task = taskModel {
                await resumeVM.carregarAlunosTarefa(task: task)
                self.isLoading = false
            }
        }
}

// MARK: - Subviews & Cards Extension

extension VisualizarDadosView {
    
    // 1. Card de Tempo
    private var timeCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "calendar.badge.exclamationmark")
                .foregroundColor(themeColor)
                .font(.system(size: 35))
            
            VStack(alignment: .leading) {
                if endDate < Date() {
                    Text("Terminou!")
                        .font(.title2.bold())
                        .foregroundColor(.black)
                } else {
                    Text("Termina em \(resumeVM.diasRestantes(ate: endDate)) dias!")
                        .font(.title2.bold())
                        .foregroundColor(.black)
                }
            }
            Spacer()
        }
        .padding(16)
        .cardStyle()
    }
    
    // 2. Card de Descrição
    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Header
            HStack(spacing: 5) {
                Text(isChallenge ? "Dados do desafio" : "Dados da tarefa")
                    .font(.title2.bold())
                
                Spacer()
                
                if isChallenge {
                    HStack(spacing: 6) {
                        Image(systemName: challengeTypeIcon)
                            .foregroundStyle(themeColor)
                        Text(challengeTypeName)
                            .font(.body.bold())
                    }
                    .padding(6)
                    .background(themeColor.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            
            Divider()
            
            // Texto Descrição
            VStack(alignment: .leading, spacing: 5) {
                Text("Descrição")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                if description.isEmpty {
                    Text("Nenhuma descrição.")
                        .font(.caption.italic())
                        .foregroundStyle(.secondary)
                } else {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.black.opacity(0.8))
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
    
    // 3. Card de Participantes
    private var participantsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Header com Ação
            Button {
                if let challenge = challengeModel {
                    onNavigate(.participantsChallenge(challenge))
                } else if let task = taskModel {
                    onNavigate(.participantsTask(task))
                }
            } label: {
                HStack {
                    Text(isChallenge ? "Participantes" : "Resultado individual")
                        .font(.title2.bold())
                        .foregroundStyle(.black)
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(themeColor)
                    Spacer()
                }
            }
            
            // Conteúdo
            VStack(alignment: .leading) {
                if isLoading {
                    loadingView
                } else {
                    if isListEmpty {
                        emptyStateView
                    } else {
                        membersList
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // Sub-componentes do Card de Participantes
    
    private var loadingView: some View {
        HStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.4)
                .tint(themeColor)
            Spacer()
        }
        .padding(.vertical, 20)
    }
    
    private var emptyStateView: some View {
        Text("Nenhum participante encontrado.")
            .font(.callout)
            .foregroundStyle(.secondary)
            .padding(.vertical, 10)
    }
    
    private var membersList: some View {
        let members = isChallenge ? resumeVM.members : resumeVM.alunosTarefas
        
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(members, id: \.id) { member in
                    Button {
                        selectedMember = member
                    } label: {
                        MemberAvatarView(image: member.profileImage, name: member.name)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    // Botão de Loading (Visual idêntico ao Start, mas com spinner)
        private var loadingButton: some View {
            Button {
                // Ação vazia, pois está carregando
            } label: {
                ProgressView()
                    .tint(.white) // Spinner branco
                    .scaleEffect(1.2)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18) // Mesma altura do original
                    .background(
                        Capsule()
                            .fill(themeColor.opacity(0.6)) // Cor um pouco mais clara para indicar disabled
                            .shadow(color: .black.opacity(0.15), radius: 5, y: 3)
                    )
            }
            .disabled(true) // Desabilita interação
            .padding(.top, 15)
            .padding(.bottom, 20)
        }
    
    private var startButton: some View {
        Button {
            // Haptics
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Ação
            startChallenge = true
            
        } label: {
            Text("Começar desafio")
                .foregroundColor(.white)
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    Capsule()
                        .fill(themeColor)
                        .shadow(color: .black.opacity(0.15), radius: 5, y: 3)
                )
        }
        .padding(.top, 15)
        .padding(.bottom, 20)
    }
    
    private var alreadyDoneChallenge: some View {
        Button {
            
            
        } label: {
            Text("Desafio já foi feito")
                .foregroundColor(.white)
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    Capsule()
                        .fill(Color("BlueCardBackground2"))
                        .shadow(color: .black.opacity(0.15), radius: 5, y: 3)
                )
        }
        .padding(.top, 15)
        .padding(.bottom, 20)
    }
}

// MARK: - Helper Components & Modifiers

struct MemberAvatarView: View {
    let image: UIImage?
    let name: String
    
    var body: some View {
        VStack {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
            }
            
            Text(name)
                .lineLimit(1)
                .frame(minWidth: 60)
                .font(.headline)
                .padding(8)
        }
    }
}

struct CardStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyleModifier())
    }
}
