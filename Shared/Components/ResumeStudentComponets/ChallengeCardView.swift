//
//  ChallengeCardView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 24/11/25.
//

import SwiftUI

struct ChallengeCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color("BlueCard"))

            VStack(spacing: 16) {
                HStack {
                    Text("Desafio")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Spacer()
                    Text("Faltam 2 dias")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }

                Image(systemName: "flag.checkered.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .padding(.top, 10)
            }
            .padding()
        }
        .frame(height: 180)
    }
}
