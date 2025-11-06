//
//  DesafioView.swift
//  OsVigaristas
//
//  Created by Erika Hacimoto on 04/11/25.
//

import SwiftUI

struct HomeView: View {
    @State private var isChallengeEmpty = true
    @State private var isTaskEmpty = true
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
                    if isChallengeEmpty {
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
                        isChallengeEmpty = false
                    } label: {
                        Text("Novo Desafio")
                            .frame(width: 350, height: 30)
                    }
                    .frame(maxWidth: .infinity, minHeight: 70)
                    .padding(.horizontal)
                    .buttonStyle(.glassProminent)
                    } else {
//                        ScrollView {
//                            VStack{
//                                Form {
////                                    LabeledContent("") {
//                                        Image("violao")
//                                        .resizable()
//                                        .frame(width: 380, height: 200)
//                                        
////                                    }
//                                }
//                                .frame(width: 380, height: 300)
//                                Form {
//                                    LabeledContent("Desafio 1") {
//                                                                    
//                                    }
//                                }
//                                Form {
//                                    LabeledContent("Desafio 1") {
//                                        
//                                    }
//                                }
//                            }
//                        }
                    }
                } else {
                    if isTaskEmpty {
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
                            isTaskEmpty = false
                        } label: {
                            Text("Nova Tarefa")
                                .frame(width: 350, height: 30)
                        }
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .padding(.horizontal)
                        .buttonStyle(.glassProminent)
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
//    HomeView()
    TabbarView()
}
