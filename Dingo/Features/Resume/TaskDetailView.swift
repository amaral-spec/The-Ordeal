//
//  DetalhesTarefasView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 12/11/25.
//

import SwiftUI

struct TaskDetailView: View {
    // Colocar uma variavel para receber a tarefa
    
    // receber o ResumeVM
    @EnvironmentObject var resumeVM: ResumeViewModel
    @EnvironmentObject var persistenceServices: PersistenceServices
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 10) {
                Text("Dados da Tarefa/desafio prof e desafio aluno")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 8)
                    .padding(.top, 4)
                    .padding(.bottom, 10)
                    .frame(width: 353, height: 42, alignment: .leading)
            }
            HStack(spacing: -10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 173, height: 108, alignment: .leading)
                        .foregroundStyle(.white)
                    
                    VStack() {
                        //trocar o texto para os dias que estão sendo contados desde o dia que a tarefa foi criada
                        Text("Terminou")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)
                            .foregroundStyle(Color.accentColor)
                            .frame(alignment: .leading)
                            .padding(.horizontal, 14)
                        
                        HStack {
                            Text("1212 Dias")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(Color.accentColor)
                                .font(.title)
                                .bold()
                                .padding(.horizontal, 14)
                        }
                    }
                    .frame(width: 173, height: 108, alignment: .leading)
                }
                .padding()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 173, height: 108, alignment: .leading)
                        .foregroundStyle(.white)
                    
                    VStack() {
                        //trocar o texto para os dias que estão sendo contados desde o dia que a tarefa foi criada
                        Text("Prêmio")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)
                            .foregroundStyle(Color.accentColor)
                            .frame(alignment: .leading)
                            .padding(.horizontal, 14)
                        Text("50 Moedas")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color.accentColor)
                            .font(.title)
                            .bold()
                            .padding(.horizontal, 14)
                    }
                }
                .padding()
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(height: 201, alignment: .center)
                    .padding(.horizontal)
                    .foregroundStyle(.white)
                VStack {
                    Text("Descrição")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(width: 321, alignment: .topLeading)
                    
                    // trocar para a descricao da tarefa
                    Text("Descrição fornecida pelo próprio professor.")
                        .frame(width: 321, height: 132, alignment: .topLeading)
                }
            }
            
            //                NavigationLink(destination: ResultadosAlunosView()) {
            HStack {
                Text("Resultado dos Alunos")
                    .font(.title2)
                    .bold()
                Image(systemName: "chevron.right")
                    .foregroundColor(.pink)
                    .foregroundStyle(Color.accentColor)
            }
            .frame(width: 355, height: 42, alignment: .leading)
            .padding(.vertical, 3)
            //                }
            ScrollView(.horizontal) {
                HStack(alignment: .center, spacing: 15) {
                    //trocar forEach para buscar do cloudKit
                    ForEach(1...8, id: \.self) { _ in
                        Circle()
                            .frame(width: 80, height: 80)
                    }
                }
                .padding(.horizontal, 27)
                .padding(.vertical, 0)
                .frame(minWidth: 403, maxWidth: 403, alignment: .leading)
            }
            Spacer()
            
            
            // Exemplo de uso de uma propriedade existente para remover o erro de if incompleto
            if resumeVM.isTeacher {
                Text("Você é professor")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                Text("Você é Aluno - começar desafio")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                EmptyView()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
        .navigationTitle("Tarefa do Barquinho")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    NavigationStack {
//        TaskDetailView()
//            .environmentObject(ResumeViewModel(isTeacher: false))
//    }
//}
