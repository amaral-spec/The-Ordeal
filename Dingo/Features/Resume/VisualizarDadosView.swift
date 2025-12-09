//
//  VisualizarDadosView.swift
//  OsVigaristas
//

import SwiftUI
import CloudKit

struct VisualizarDadosView: View {
    // MARK: - Properties
    let isChallenge: Bool
    let challengeModel: ChallengeModel?
    let taskModel: TaskModel?
    let onNavigate: (ResumeCoordinatorView.Route) -> Void
    
    @EnvironmentObject var resumeVM: ResumeViewModel
    
    // States locais apenas para interação
    @State private var selectedMember: UserModel?
    @State private var startChallenge: Bool = false
    
    @StateObject var doChallengeVM = DoChallengeViewModel(
        persistenceServices: PersistenceServices()
    )
    
    // MARK: - Computed Properties (Lógica de exibição)
    
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
    
    // NOVO: Helper para o nome do tipo de desafio
    private var challengeTypeName: String {
        guard let type = challengeModel?.whichChallenge else { return "" }
        switch type {
        case 1: return "Ecco"
        case 2: return "Encadeia"
        default: return "Desconhecido"
        }
    }
    
    // NOVO: Helper para o ícone do tipo de desafio
    private var challengeTypeIcon: String {
        guard let type = challengeModel?.whichChallenge else { return "questionmark" }
        switch type {
        case 1: return "waveform" // Ícone para Echo
        case 2: return "link"     // Ícone para Encadeia
        default: return "circle"
        }
    }
    
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
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                timeCard
                descriptionCard
                participantsCard
            }
            .padding(20)
        }
        .background(Color(.secondarySystemBackground))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        // Sheets & Overlays
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
        // Data Loading
        .task {
            if isChallenge, let challenge = challengeModel {
                await resumeVM.carregarParticipantesPorDesafio(challenge: challenge)
            } else if let task = taskModel {
                await resumeVM.carregarAlunosTarefa(task: task)
            }
        }
    }
}

// MARK: - Subviews & Cards
extension VisualizarDadosView {
    
    // 1. Card de Tempo
    private var timeCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "calendar.badge.exclamationmark")
                .foregroundColor(themeColor)
                .font(.system(size: 35))
            
            if endDate < Date() {
                Text("Terminou!")
                    .font(.title2.bold())
                    .foregroundColor(.black)
            } else {
                Text("Termina em \(resumeVM.diasRestantes(ate: endDate)) dias!")
                    .font(.title2.bold())
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding(16)
        .cardStyle()
    }
    
    // 2. Card de Descrição (MODIFICADO)
    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Título Geral do Card
            HStack( spacing: 5) {
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
                        
            // Descrição
            VStack(alignment: .leading, spacing: 5) {
                Text("Descrição")
                    .font(.headline) // Ajustei para headline para ficar hierarquicamente correto
                    .foregroundStyle(.secondary)
                
                if description.isEmpty {
                    Text("Nenhuma descrição.")
                        .font(.caption.italic())
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
            // Header clicável
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
            
            // Lista ou Loading
            VStack(alignment: .leading) {
                if isListEmpty {
                    HStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.4)
                            .tint(themeColor)
                        Spacer()
                    }
                    .padding(.vertical, 20)
                } else {
                    membersList
                }
                
                // Botão de Começar (Apenas Desafio e Aluno)
                if isChallenge && !resumeVM.isTeacher {
                    startButton
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // Lista horizontal unificada visualmente
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
    
    private var startButton: some View {
        Button {
            startChallenge = !doChallengeVM.isCompleted
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
}

// MARK: - Reusable Components

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
