//
//  listaParticipantesView.swift
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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(resumeVM.members.indices, id: \.self) { index in
                    let member = resumeVM.members[index]
                    
                    HStack {
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
                        
                        Text(member.name)
                            .padding(.horizontal)
                            .font(.title2)
                            .foregroundColor(.black.opacity(0.7))
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    
                    if isTeacher {
                        if let audio = resumeVM.audioFor(member: member) {
                            MemberAudioRow(member: member, audio: audio)
                        } else {
                            // Sem áudio
                            Text("Nenhum áudio enviado")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.leading, 20)
                        }
                    }
                    
                    if index <= resumeVM.members.count - 1 {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))
                            .padding(.leading, 80)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.horizontal, 10)
        }
        .refreshable {
            if let challengeModel {
                await resumeVM.carregarParticipantesPorDesafio(challenge: challengeModel)
                await resumeVM.carregarAudios(challengeID: challengeModel.id)
            }
        }
        .navigationTitle("Participantes")
        .task {
            if let challengeModel {
                await resumeVM.carregarParticipantesPorDesafio(challenge: challengeModel)
                await resumeVM.carregarAudios(challengeID: challengeModel.id)
            }
        }
    }
}
