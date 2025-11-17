//
//  VisualizarDadosView.swift
//  OsVigaristas
//
//  Created by Jordana Lourenço Santos on 17/11/25.
//

import SwiftUI

struct VisualizarDadosView: View {
    var body: some View {
        NavigationStack{
            VStack{
                //colocar titulo dinamico aqui
                Dados()
                listaParticipante()
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
    }
}

struct listaParticipante: View {
    var body: some View {
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
    }
}


#Preview {
    VisualizarDadosView()
}
