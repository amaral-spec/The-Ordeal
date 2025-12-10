//
//  TarefasList.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 26/11/25.
//

import SwiftUI
import Foundation

struct TarefasList: View {
    @State private var criarTarefa = false
    @ObservedObject var resumoVM: ResumeViewModel
    
    let onNavigate: (ResumeCoordinatorView.Route) -> Void
    
    @State var startTask: Bool = false
    @State private var alreadyDone: Bool = false
    
    @StateObject var doTaskVM = DoTaskViewModel(
        persistenceServices: PersistenceServices()
    )
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(resumoVM.tasks) { tarefa in
                    if(resumoVM.isTeacher){ //professor
                        if(tarefa.endDate < Date()){
                            ListCard(title: tarefa.title, subtitle: "Resultado", image: GrayTaskImage())
                                .onTapGesture {
                                    resumoVM.alunosTarefas = []
                                    onNavigate(.detailTask(tarefa))
                                }
                            
                        } else{
                            ListCard(title: tarefa.title, subtitle: "", image: TaskImage())
                                .onTapGesture {
                                    resumoVM.alunosTarefas = []
                                    onNavigate(.detailTask(tarefa))
                                }
                        }
                    } else { //aluno
                        if(tarefa.endDate >= Date()){
                            ListCard(title: tarefa.title, subtitle: "Faça até \(resumoVM.formatarDiaMes(tarefa.endDate))!", image: TaskImage())
                                .onTapGesture {
                                    Task { @MainActor in
                                        alreadyDone = await doTaskVM.isHeAlreadyDoneThisTask(taskID: tarefa.id)
                                        if !alreadyDone {
                                            doTaskVM.taskM = tarefa
                                            resumoVM.alunosTarefas = []
                                            startTask = true
                                        } else {
                                            withAnimation {
                                                alreadyDone = true
                                            }
                                            
                                            // Removes feedback after 2.0 seconds
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                withAnimation {
                                                    self.alreadyDone = false
                                                }
                                            }
                                            
                                            // Haptics
                                            let generator = UINotificationFeedbackGenerator()
                                            generator.notificationOccurred(.success)
                                        }
                                    }
                                }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .overlay(alignment: .top) {
            if alreadyDone {
                Text("Você já fez essa tarefa")
                    .font(.headline)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color("BlueCard"))
                    .foregroundStyle(.white)
                    .cornerRadius(30)
                    .padding(.top, 40)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(duration: 0.4), value: alreadyDone)
            }
        }
        .background(Color(.secondarySystemBackground))
        .navigationTitle("Tarefas")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            await resumoVM.carregarTarefas()
        }
        .task {
            await resumoVM.carregarTarefas()
        }
        .toolbar(){
            if(resumoVM.isTeacher){
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        criarTarefa = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color(.black))
                    }
                }
            }
        }
        .sheet(isPresented: $criarTarefa) {
            CriarTarefaView(numTask: .constant(0))
        }
        .sheet(isPresented: $startTask) {
            DoTaskCoordinatorView(doTaskVM: doTaskVM)
        }
    }
}

