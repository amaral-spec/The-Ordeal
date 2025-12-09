//
//  CriarGrupoView 2.swift
//  Dingo
//
//  Created by Erika Hacimoto on 02/12/25.
//

import SwiftUI
import CloudKit

struct DetailEachAluno: View {
    @Environment(\.dismiss) var dismiss
    let member: UserModel

    var body: some View {
        NavigationStack {
            VStack {
                if let image = member.profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding(.top, 30)
                }
                VStack(spacing: -10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 45)
                            .frame(height: 60)
                            .foregroundStyle(.white)

                        HStack {
                            Image(systemName: "flame.fill")
                                .font(.largeTitle)
                                .foregroundStyle(Color("RedCard"))

                            Text("\(member.streak) dias de ofensiva!")
                                .font(.title2)
                        }
                        .padding(.trailing, 90)
                    }
                    .padding(25)

                    HStack(spacing: 15) {
                        CardPerfil(texto: "Última tarefa: \n\(member.lastTask?.endDate.formatted(date: .numeric, time: .omitted) ?? "No data")")
                        CardPerfil(texto: "Último desafio: \n\(member.lastChallenge?.endDate.formatted(date: .numeric, time: .omitted) ?? "No data")")
                    }
                    .padding([.horizontal], 25)
                }
                Spacer()
            }
            .frame(width: .infinity, height: .infinity)
            .background(Color(.secondarySystemBackground))
            .navigationTitle("\(member.name)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    DetailEachAluno(member: )
//}
