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
            .frame(width: 350, height: 100, alignment: .top)
            Spacer(minLength: 100)
            VStack (spacing: -15){
                if Mode.Desafio == selectedMode {
                    if isChallengeEmpty {
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
                        
                        Button("Novo Desafio") {
                            
                        }
                        .frame(height: 50)
                        .buttonStyle(.glassProminent)
                    }
                } else {
                    if isTaskEmpty {
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
                        
                        Button("Nova Tarefa") {
                            
                        }
                        .frame(height: 50)
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
