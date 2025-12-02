//
//  StreakCardView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 24/11/25.
//

import SwiftUI

struct StreakCardView: View {
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundColor(Color("RedCard"))
                    .font(.system(size: 32))

                Text("20")
                    .font(.title3.bold())
            }
            .frame(width: 50, alignment: .center)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 20) {
                    ForEach(["D","S","T","Q","Q","S","S"], id: \.self) { day in
                        VStack(spacing: 4) {
                            Text(day)
                                .font(.caption2)

                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color("RedCard"))
                        }
                    }
                }

                Text("Atenção! Uma semana sem treinar zera a streak")
                    .font(.caption2.italic())
                    .foregroundColor(.gray)
            }
        }
        .padding(.all, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        )
    }
}

#Preview {
    StreakCardView()
}
