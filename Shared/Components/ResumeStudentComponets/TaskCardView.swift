//
//  TaskCardView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 24/11/25.
//

import SwiftUI

struct TaskCardView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Tarefas")
                .font(.headline)
                .foregroundColor(.white)

            Image(systemName: "checklist")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("GreenCard"))
        )
        .frame(height: 160)
    }
}
