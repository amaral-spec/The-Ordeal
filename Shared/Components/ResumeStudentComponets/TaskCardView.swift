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
            RoundedRectangle(cornerRadius: 20)
                .fill(resumoVM.tasks.isEmpty ? .gray : Color("GreenCard"))
                .frame(height: 160)
            if resumoVM.tasks.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.4)
                    .tint(.white)
            } else {
                ZStack {
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
            }
        }
        .frame(height: 160)
        .task {
            await resumoVM.carregarTarefas()
        }
    }
}
