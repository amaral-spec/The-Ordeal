//
//  TrainingCardView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 24/11/25.
//

import SwiftUI

import SwiftUI

struct TrainingCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("RedCard"))
                .frame(height: 160)
            
            VStack {
                HStack {
                    Text("Treino")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                Spacer()
            }
            .padding(16)

            Image("custom.music.pages.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .padding(.top, 20)
                .foregroundColor(.white)
        }
        .frame(height: 160)
    }
}

#Preview {
    TrainingCardView()
}
