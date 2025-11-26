//
//  VisualizarDadosView.swift
//  OsVigaristas
//

import SwiftUI

struct VisualizarDadosView: View {
    @EnvironmentObject var resumeVM: ResumeViewModel
    @State var challengeModel: ChallengeModel?
    @State var taskModel: TaskModel?
    
    @State private var endDate: Date
    @State private var description: String
    @State private var title: String
    @State private var participants: [String] = []
    
    init(challengeModel: ChallengeModel? = nil, taskModel: TaskModel? = nil) {
        if let challengeModel = challengeModel {
            self.challengeModel = challengeModel
            self.endDate = challengeModel.endDate
            self.description = challengeModel.description
            self.title = challengeModel.whichChallenge == 1 ? "Echo" : "Encadeia"
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
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - CARD 1: Tempo Restante
                VStack {
                    HStack(spacing: 12) {
                        
                        Image(systemName: "calendar.badge.exclamationmark")
                            .foregroundColor(Color("BlueCard"))
                            .font(.system(size: 35))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Termina em \(resumeVM.diasRestantes(ate: endDate)) dias!")
                                .font(.title2.bold())
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
                )
                
                
                // MARK: - CARD 2: Descrição
                Section("Dados do Desafio") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Descrição")
                            .font(.title2.bold())
                        
                        Text(description)
                            .font(.title2)
                            .foregroundColor(.black.opacity(0.8))
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
                    )
                }
                .font(.title2.bold())
                
                
                // MARK: - CARD 3: Participantes
                VStack(alignment: .leading, spacing: 12) {
                    Text("Participantes")
                        .font(.title2.bold())
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(participants.indices, id: \.self) { index in
                                VStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 60, height: 60)
                                    
                                    Text("Aluno \(index + 1)")
                                        .font(.caption2)
                                        .foregroundColor(.black.opacity(0.6))
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
