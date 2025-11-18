//
//  PerfilView.swift
//  OsVigaristas
//
//  Created by Jordana Lourenço Santos on 18/11/25.
//

import SwiftUI

struct PerfilView: View {
    var body: some View {
        NavigationStack {
            VStack(){
                ScrollView(){
                    Image("partitura")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding()
                    
                    Text("João da Silva")
                        .font(.title)
                    
                    Text("Aluno desde 18/11/2025")
                        .font(.caption)
                        .foregroundColor(Color("AccentColor"))
                    
                    HStack{
                        CardPerfil(texto: "40 B")
                        CardPerfil(texto: "4 F")
                    }
                    .padding(.top, 20)
                    
                    HStack{
                        CardPerfil(texto: "Última tarefa: \n13/11/25")
                        CardPerfil(texto: "Último desafio: \n13/11/25")
                    }
                    
                    Button(action:{}){
                        Row(texto: "Entrar em um grupo")
                    }
                    .buttonStyle(.plain)
                    
                    Button(action:{}){
                        Row(texto: "Histórico de tarefas")
                    }
                    .buttonStyle(.plain)
                    
                    Button(action:{}){
                        ZStack{
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 350, height: 50)
                                .padding(10)
                                .foregroundStyle(.gray.opacity(0.3))
                            
                            Text("Sair")
                        }
                    }
                }
            }
            .navigationTitle("Perfil")
        }
    }
}

struct CardPerfil: View {
    @State var texto: String
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 150, height: 100)
                .padding(10)
                .foregroundStyle(.gray.opacity(0.3))
            
            Text(texto)
                .multilineTextAlignment(.center)
        }
    }
}

struct Row: View {
    @State var texto: String
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 350, height: 50)
                .padding(10)
                .foregroundStyle(.gray.opacity(0.3))
            
            HStack {
                Text(texto)

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }.padding(.horizontal, 40)
        }
    }
}

#Preview {
    PerfilView()
}
