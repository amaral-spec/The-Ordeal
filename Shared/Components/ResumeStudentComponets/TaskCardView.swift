//
//  TaskCardView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 24/11/25.
//

import SwiftUI

struct TaskCardView: View {
    @ObservedObject var resumoVM: ResumeViewModel

    var body: some View {
        ZStack {
            if resumoVM.tasks.isEmpty {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.gray)
                    .frame(height: 160)
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("GreenCard"))
                    .frame(height: 160)
            }
            VStack {
                HStack {
                    Text("Tarefas")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                Spacer()
            }
            .padding(16)

            Image("custom.checklist.checked.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .padding(.top, 20)
                .foregroundColor(.white)
        }
        .frame(height: 160)
        .task {
            await resumoVM.carregarTarefas()
        }
    }
}


