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
        ZStack {
            if let challengeModel {
                if resumeVM.members.isEmpty {
                    VStack {
                        Spacer(minLength: 200)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.4)
                            .tint(Color("BlueCard"))
                        Spacer(minLength: 200)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                if resumeVM.alunosTarefas.isEmpty {
                    VStack {
                        Spacer(minLength: 200)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.4)
                            .tint(Color("GreenCard"))
                        Spacer(minLength: 200)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    if let challengeModel {
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
                                if resumeVM.audios.isEmpty {
                                    HStack {
                                        ProgressView()
                                            .scaleEffect(1.2)
                                        Text("Carregando áudio...")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Spacer()
                                    }
                                    .padding(.leading, 20)
                                    .padding(.vertical, 4)
                                    
                                } else if let audio = resumeVM.audioFor(member: member) {
                                    MemberAudioRow(member: member, audio: audio)
                                }
                            }
                            
                            if index <= resumeVM.members.count - 1 {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray.opacity(0.25))
                                    .padding(.top, 10)
                                    .padding(.bottom, 6)
                                    .padding(.horizontal, -20)
                            }
                        }
                    } else {
                        ForEach(resumeVM.alunosTarefas.indices, id: \.self) { index in
                            let aluno = resumeVM.alunosTarefas[index]
                            
                            HStack {
                                if let uiImage = aluno.profileImage {
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
                                
                                Text(aluno.name)
                                    .padding(.horizontal)
                                    .font(.title2)
                                    .foregroundColor(.black.opacity(0.7))
                                
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            
                            if isTeacher {
                                if resumeVM.audios.isEmpty {
                                    HStack {
                                        ProgressView()
                                            .scaleEffect(1.2)
                                        Text("Carregando áudio...")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Spacer()
                                    }
                                    .padding(.leading, 20)
                                    .padding(.vertical, 4)
                                    
                                } else if let audio = resumeVM.audioFor(member: aluno) {
                                    MemberAudioRow(member: aluno, audio: audio)
                                }
                            }
                            
                            if index <= resumeVM.alunosTarefas.count - 1 {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray.opacity(0.25))
                                    .padding(.top, 10)
                                    .padding(.bottom, 6)
                                    .padding(.horizontal, -20)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.horizontal, 10)
            }
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
