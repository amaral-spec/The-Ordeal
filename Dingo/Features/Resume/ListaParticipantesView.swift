//
//  ListaParticipantesView.swift
//  OsVigaristas
//
//  Created by Jordana Lourenço Santos on 17/11/25.
//

import SwiftUI

struct ListaParticipantesView: View {
    let isTeacher: Bool
    
    @EnvironmentObject var resumeVM: ResumeViewModel
    @State var challengeModel: ChallengeModel?
    @State var taskModel: TaskModel?
    
    // Variável que controla o Timeout
    @State private var audioLoadingTimeoutReached: Bool = false
    
    var body: some View {
        ZStack {
            // MARK: - Estado de Loading Inicial (Tela cheia)
            if challengeModel != nil {
                if resumeVM.members.isEmpty {
                    loadingView(colorName: "BlueCard")
                }
            } else {
                if resumeVM.alunosTarefas.isEmpty {
                    loadingView(colorName: "GreenCard")
                }
            }
            
            // MARK: - Lista (Card Style)
            ScrollView {
                // Container Branco (Estilo Apple Health)
                VStack(alignment: .leading, spacing: 0) {
                    
                    if challengeModel != nil {
                        // Lógica para Challenge
                        ForEach(resumeVM.members.indices, id: \.self) { index in
                            let member = resumeVM.members[index]
                            
                            VStack(spacing: 0) {
                                rowContent(
                                    image: member.profileImage,
                                    name: member.name,
                                    item: member,
                                    colorName: "BlueCard"
                                )
                                
                                if index < resumeVM.members.count - 1 {
                                    Divider()
                                        .padding(.leading, 80)
                                        .padding(.trailing, 16)
                                }
                            }
                        }
                    } else {
                        // Lógica para Task
                        ForEach(resumeVM.alunosTarefas.indices, id: \.self) { index in
                            let aluno = resumeVM.alunosTarefas[index]
                            
                            VStack(spacing: 0) {
                                rowContent(
                                    image: aluno.profileImage,
                                    name: aluno.name,
                                    item: aluno,
                                    colorName: "GreenCard"
                                )
                                
                                if index < resumeVM.alunosTarefas.count - 1 {
                                    Divider().padding(.leading, 80)
                                }
                            }
                        }
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
        }
        .background(Color(.systemGroupedBackground))
        .refreshable {
            // Reinicia o estado do timeout ao puxar para atualizar
            audioLoadingTimeoutReached = false
            iniciarTimeoutAudios()
            
            if let challengeModel {
                await resumeVM.carregarParticipantesPorDesafio(challenge: challengeModel)
                await resumeVM.carregarAudios(challengeID: challengeModel.id)
            }
            if let taskModel {
                await resumeVM.carregarParticipantesPorTarefa(task: taskModel)
                await resumeVM.carregarAudios(taskID: taskModel.id)
            }
        }
        .navigationTitle("Participantes")
        .onAppear() {
            resumeVM.audios = []
        }
        .task {
            // Inicia o contador de 10 segundos
            iniciarTimeoutAudios()
            
            if let challengeModel {
                await resumeVM.carregarParticipantesPorDesafio(challenge: challengeModel)
                await resumeVM.carregarAudios(challengeID: challengeModel.id)
            }
            if let taskModel {
                await resumeVM.carregarParticipantesPorTarefa(task: taskModel)
                await resumeVM.carregarAudios(taskID: taskModel.id)
            }
        }
    }
    
    // MARK: - Função de Timeout
    func iniciarTimeoutAudios() {
        Task {
            // Espera 10 segundos (10 * 1 bilhão de nanosegundos)
            try? await Task.sleep(nanoseconds: 10_000_000_000)
            
            // Atualiza na Main Thread
            await MainActor.run {
                withAnimation {
                    self.audioLoadingTimeoutReached = true
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    func loadingView(colorName: String) -> some View {
        VStack {
            Spacer(minLength: 200)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.4)
                .tint(Color(colorName))
            Spacer(minLength: 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    func rowContent(image: UIImage?, name: String, item: Any, colorName: String) -> some View {
        HStack {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray.opacity(0.5))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                if isTeacher {
                    // SE não tiver áudios carregados na ViewModel
                    if resumeVM.audios.isEmpty {
                        
                        // Verifica se já passou os 10 segundos
                        if audioLoadingTimeoutReached {
                            Text("Sem áudio") // Timeout atingido
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            // Ainda está dentro dos 10 segundos
                            HStack(spacing: 6) {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(Color(colorName))
                                Text("Buscando áudio...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        // Áudios encontrados, exibe o player
                        
                        // Exemplo de cast seguro (ajuste 'UserModel' para sua classe real de Membro/Aluno)
                        if let memberItem = item as? UserModel, let audio = resumeVM.audioFor(member: memberItem) {
                             MemberAudioRow(member: memberItem, audio: audio)
                        }
                        // Fallback visual caso precise testar sem o modelo exato
                        else if let _ = item as? Any {
                            // Placeholder caso a lógica de audioFor falhe ou modelo não bata
                             // MemberAudioRow(...)
                        }
                    }
                }
            }
            .padding(.leading, 8)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
