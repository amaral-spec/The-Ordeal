//
//  TrainingCardView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 24/11/25.
//

import SwiftUI

struct TrainingCardView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Treino")
                .font(.headline)
                .foregroundColor(.white)

            Image(systemName: "music.note.list")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("RedCard"))
        )
        .frame(height: 160)
    }
}
