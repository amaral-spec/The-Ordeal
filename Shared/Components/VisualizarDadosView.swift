//
//  VisualizarDadosView.swift
//  OsVigaristas
//

import SwiftUI

struct VisualizarDadosView: View {
    let isChallenge: Bool
    
    @EnvironmentObject var resumeVM: ResumeViewModel
    @State var challengeModel: ChallengeModel?
    @State var taskModel: TaskModel?
    
    @State private var endDate: Date
    @State private var description: String
    @State private var title: String
    @State private var participants: [String] = []
    
    @State var startChallenge: Bool = false
    let onNavigate: (ResumeCoordinatorView.Route) -> Void
    
    init(isChallenge: Bool, challengeModel: ChallengeModel? = nil, taskModel: TaskModel? = nil, onNavigate: @escaping (ResumeCoordinatorView.Route) -> Void) {
        if let challengeModel = challengeModel {
            self.challengeModel = challengeModel
            self.endDate = challengeModel.endDate
            self.description = challengeModel.description
            self.title = challengeModel.title
        } else if let taskModel = taskModel {
            self.taskModel = taskModel
            self.endDate = taskModel.endDate
            self.description = taskModel.description
            self.title = taskModel.title
        } else {
            self.endDate = Date()
            self.description = ""
            self.title = ""
        }
        self.onNavigate = onNavigate
        self.isChallenge = isChallenge
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - CARD 1: Tempo Restante
                VStack {
                    HStack(spacing: 12) {
                        if isChallenge {
                            Image(systemName: "calendar.badge.exclamationmark")
                                .foregroundColor(Color("BlueCard"))
                                .font(.system(size: 35))
                        } else {
                            Image(systemName: "calendar.badge.exclamationmark")
                                .foregroundStyle(Color("GreenCard"))
                                .font(.system(size: 35))
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Termina em \(resumeVM.diasRestantes(ate: endDate)) dias!")
                                .font(.title2.bold())
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
                )
                
                
                // MARK: - CARD 2: Descrição
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Dados do Desafio")
                        .font(.title2.bold())
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Descrição")
                            .font(.title3.bold())
                        
                        if description.isEmpty {
                            Text("Nenhuma descrição.")
                                .font(.caption.italic())
                        } else {
                            Text(description)
                                .font(.title3)
                                .foregroundColor(.black.opacity(0.8))
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
                    )
                }
                
                
                // MARK: - CARD 3: Participantes
                VStack(alignment: .leading, spacing: 12) {
                    Button {
                        if let challengeModel = challengeModel {
                            onNavigate(.participants(challengeModel))
                        }
                    } label: {
                        HStack {
                            if isChallenge {
                                Text("Participantes")
                                    .font(.title2.bold())
                                    .foregroundStyle(.black)
                            } else {
                                Text("Resultado individual")
                                    .font(.title2.bold())
                                    .foregroundStyle(.black)
                            }
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color("BlueCard"))
                            
                            Spacer()
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        
                        if resumeVM.members.isEmpty {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(1.4)
                                Spacer()
                            }
                            .padding(.vertical, 20)
                            
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    
                                    ForEach(resumeVM.members) { member in
                                        VStack(spacing: 8) {
                                            
                                            if let uiImage = member.profileImage {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 70, height: 70)
                                                    .clipShape(Circle())
                                            } else {
                                                Image(systemName: "person.crop.circle.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 70, height: 70)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }
                            }
                            if isChallenge {
                                Button {
                                    startChallenge = true
                                } label: {
                                    Text("Começar desafio")
                                        .foregroundColor(.white)
                                        .font(.title3.bold())
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 18)
                                        .background(
                                            Capsule()
                                                .fill(Color("BlueCard"))
                                                .shadow(color: .black.opacity(0.15), radius: 5, y: 3)
                                        )
                                }
                                .padding(.top, 15)
                                .padding(.bottom, 20)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                
            }
            .padding(20)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $startChallenge) {
            DoChallengeCoordinatorView(challengeM: challengeModel!)
                .interactiveDismissDisabled(true)
        }
        .task {
            if isChallenge {
                if let challengeModel {
                    await resumeVM.carregarParticipantesPorDesafio(challenge: challengeModel)
                }
            } else {
                // chamar funcao que carrega participante de cada tarefa
            }
        }
    }
}
