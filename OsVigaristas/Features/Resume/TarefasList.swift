//
//  TarefasList.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 26/11/25.
//

import SwiftUI

struct TarefasList: View {
    @ObservedObject var resumoVM: ResumeViewModel
    let onNavigate: (ResumeCoordinatorView.Route) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(resumoVM.tasks) { tarefa in
                    if(resumoVM.isTeacher){
                        if(tarefa.endDate < Date()){
                            ListCard(title: tarefa.title, subtitle: "Resultado", image: GrayTaskImage())
                                .onTapGesture {
                                    onNavigate(.detailTask(tarefa))
                                }
                            
                        } else{
                            ListCard(title: tarefa.title, subtitle: "", image: TaskImage())
                                .onTapGesture {
                                    onNavigate(.detailTask(tarefa))
                                }
                        }
                    } else {
                        if(tarefa.endDate > Date()){
                            ListCard(title: tarefa.title, subtitle: "Faça até \(resumoVM.formatarDiaMes(tarefa.endDate))!", image: TaskImage())
                            
                        }
                    }
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

