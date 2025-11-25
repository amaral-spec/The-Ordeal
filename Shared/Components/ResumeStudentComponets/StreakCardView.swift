//
//  StreakCardView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 24/11/25.
//

import SwiftUI

struct StreakCardView: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 28))
                Text("20")
                    .font(.title.bold())
                Spacer()
            }

            HStack(spacing: 16) {
                ForEach(["D", "S", "T", "Q", "Q", "S", "S"], id: \.self) { day in
                    VStack(spacing: 4) {
                        Text(day)
                            .font(.caption2)
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.pink)
                    }
                }
            }

            Text("Atenção! Uma semana sem treinar zera a streak")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        )
    }
}
