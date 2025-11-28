//
//  TarefasList.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 26/11/25.
//

import SwiftUI

struct TarefasList: View {
    @ObservedObject var resumoVM: ResumeViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(resumoVM.tasks) { tarefa in
                    
                    HStack(spacing: 16) {
                        
                        ZStack {
                            if tarefa.endDate < Date(){
                                Circle()
                                    .fill(.gray)
                                    .frame(width: 45, height: 45)
                            } else {
                                Circle()
                                    .fill(Color("GreenCard"))
                                    .frame(width: 45, height: 45)
                            }
                            
                            Image(systemName: "checklist.checked")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                        }
                        
                        Text(tarefa.title)
                            .font(.title3.bold())
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        if tarefa.endDate < Date(){
                            Text("Resultado")
                                .font(.caption.italic())
                                .foregroundColor(.black)
                        } else {
                            Text("Faça até \(resumoVM.formatarDiaMes(tarefa.endDate))!")
                                .font(.caption.italic())
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.12), radius: 5, y: 3)
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .navigationTitle("Tarefas")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await resumoVM.carregarTarefas()
        }
    }
}

#Preview {
    TarefasList(resumoVM: ResumeViewModel(persistenceServices: PersistenceServices(), isTeacher: false))
}

