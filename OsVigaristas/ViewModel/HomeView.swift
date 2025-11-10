//
//  DesafioView.swift
//  OsVigaristas
//
//  Created by Erika Hacimoto on 04/11/25.
//

import SwiftUI

struct HomeView: View {
    @State private var numChallenge: Int = 0
    @State private var numTask: Int = 0
    enum Mode: String, CaseIterable {
        case Desafio, Tarefa
    }
    @State private var selectedMode = Mode.Desafio
    var body: some View {
        NavigationStack {
            Picker("", selection: $selectedMode) {
                ForEach(Mode.allCases, id: \.self) { mode in Text(mode.rawValue) }
            }
            .pickerStyle(.segmented)
            .frame(width: 350, height: 30, alignment: .center)
            VStack (spacing: -15){
                if Mode.Desafio == selectedMode {
                    if numChallenge == 0 {
                        Spacer(minLength: 100)
                        ZStack {
                            Image(systemName: "flag.pattern.checkered.2.crossed")
                                .foregroundColor(Color.accentColor)
                            Circle()
                                .fill(Color.accentColor)
                                .opacity(0.3)
                                .frame(width: 50, height: 50, alignment: .center)
                                .padding()
                                                }
                            VStack (spacing: -15){
                            Text("Sem Desafios")
                                .font(.title3)
                                .foregroundColor(.primary)
                                .fontWeight(.bold)
                                .padding()
                            Text("Você não possui nenhum desafio")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .fontWeight(.medium)
                        }
                        Spacer()
                        
                        Button {
                            numChallenge += 1
                        } label: {
                            Text("Novo Desafio")
                                .frame(maxWidth: 320, maxHeight: 30)
                        }
                        .frame(minWidth: 350, minHeight: 70)
                        .padding(.horizontal)
                        .buttonStyle(.glassProminent)
                    } else {
//                        ForEach(0..<10)
                        ScrollView{
                        VStack {
                            Spacer()
                            ZStack {
                                Image("violao")
                                    .resizable()
                            }
                            .frame(width: 370, height: 190)
                            .cornerRadius(30)
                            }
                            Spacer(minLength: 20)
                            ZStack {
                                Image("violao")
                                    .resizable()
                            }
                            .frame(width: 370, height: 190)
                            .cornerRadius(30)
                        }
                    }
                } else {
                    if numTask == 0 {
                        Spacer(minLength: 100)
                        ZStack {
                            Image(systemName: "checklist.checked")
                                .foregroundColor(Color.accentColor)
                            Circle()
                                .fill(Color.accentColor)
                                .opacity(0.3)
                                .frame(width: 50, height: 50, alignment: .center)
                                .padding()
                        }
                        
                        Text("Sem Tarefas")
                            .font(.title3)
                            .foregroundColor(.primary)
                            .fontWeight(.bold)
                            .padding()
                        Text("Você não possui nenhuma tarefa")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Button {
                            numTask += 1
                        } label: {
                            Text("Nova Tarefa")
                                .frame(maxWidth: 320, maxHeight: 30)
                        }
                        .frame(maxWidth: 350, minHeight: 70)
                        .padding(.horizontal)
                        .buttonStyle(.glassProminent)
                    } else {
                        ScrollView{
                            VStack (spacing: 20) {
                                Spacer()
                                ZStack {
                                    Image("violao")
                                        .resizable()
                                }
                                .frame(width: 370, height: 190)
                                .cornerRadius(30)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Resumo")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Adicionar", systemImage: "plus") {
                        
                    }
                }
            }
        }
    }
}

#Preview {
    TabbarView()
}
