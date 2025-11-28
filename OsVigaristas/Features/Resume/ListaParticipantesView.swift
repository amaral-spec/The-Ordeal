//
//  listaParticipantesView.swift
//  OsVigaristas
//
//  Created by Jordana Lourenço Santos on 17/11/25.
//

import SwiftUI

struct ListaParticipantesView: View {
    @EnvironmentObject var resumeVM: ResumeViewModel
    @State var challengeModel: ChallengeModel?
    
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
        .navigationTitle("Participantes")
        .task {
            if let challengeModel {
                await resumeVM.carregarParticipantesPorDesafio(challenge: challengeModel)
            }
        }
    }
}

#Preview {
    ListaParticipantesView()
}
