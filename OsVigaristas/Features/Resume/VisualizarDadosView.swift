//
//  VisualizarDadosView.swift
//  OsVigaristas
//
//  Created by Jordana Lourenço Santos on 17/11/25.
//

import SwiftUI

struct VisualizarDadosView: View {
    @StateObject var resumeVM: ResumeViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                //colocar titulo dinamico para o caso desafio/tarefa
                Dados()
                listaParticipante(resumeVM: ResumeViewModel(isTeacher: true))
                Spacer()
            }
            .navigationTitle("visualizar dados")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Dados: View {
    var body: some View {
        HStack(spacing: -10) {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 173, height: 108, alignment: .leading)
                    .foregroundStyle(.gray.opacity(0.3)) //mudar dps
                
                VStack() {
                    //trocar o texto para os dias que estão sendo contados desde o dia que a tarefa foi criada
                    Text("Terminou")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                        .foregroundStyle(Color.accentColor)
                        .padding(.horizontal, 15)
                    
                    Text("1212 Dias")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.accentColor)
                        .font(.title)
                        .bold()
                        .padding(.horizontal, 15)
                }
                .frame(width: 173, height: 108)
            }
            .padding()
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 173, height: 108, alignment: .leading)
                    .foregroundStyle(.gray.opacity(0.3)) //mudar dps
                
                VStack() {
                    //trocar o texto para os dias que estão sendo contados desde o dia que a tarefa foi criada
                    Text("Prêmio")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                        .foregroundStyle(Color.accentColor)
                        .padding(.horizontal, 15)
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
                .foregroundStyle(.gray.opacity(0.3))
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
    }
}

struct listaParticipante: View {
    @StateObject var resumeVM: ResumeViewModel
    
    var body: some View {
        HStack {
            Button(action: {}) {
                resumeVM.isTeacher ? Text("Resultados dos alunos").fontWeight(.bold) : Text("Participantes").fontWeight(.bold)
            }
            .buttonStyle(.plain)
            
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
    }
}


#Preview {
    VisualizarDadosView(resumeVM: ResumeViewModel())
}
