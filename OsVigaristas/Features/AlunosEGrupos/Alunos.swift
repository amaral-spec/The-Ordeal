//
//  AlunosView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 06/11/25.
//

import SwiftUI

enum Mode: String, CaseIterable {
    case Alunos, Grupos
}

let columns: [GridItem] = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
]

struct AlunosView: View {
    @State private var isStudentsEmpty = true
    @State private var isGroupsEmpty = true
    @State private var selectedMode = Mode.Alunos
    @State private var criarGrupo = false
    
    enum Mode: String, CaseIterable {
        case Alunos, Grupos
    }
    
    var body: some View {
        NavigationStack {
            Picker("", selection: $selectedMode) {
                ForEach(Mode.allCases, id: \.self) { mode in Text(mode.rawValue) }
            }
            .pickerStyle(.segmented)
            .frame(width: 350, height: 30, alignment: .center)
            
            VStack (spacing: -15){
                if Mode.Alunos == selectedMode {
                    if isStudentsEmpty {
                        Spacer(minLength: 100)
                        ZStack {
                            Image(systemName: "person.3.fill")
                                .foregroundColor(Color(red: 0.65, green: 0.13, blue: 0.29))
                            Circle()
                                .fill(Color(red: 0.65, green: 0.13, blue: 0.29))
                                .opacity(0.3)
                                .frame(width: 50, height: 50, alignment: .center)
                                .padding()
                        }
                        VStack (spacing: -15){
                            Text("Sem alunos")
                                .font(.title3)
                                .foregroundColor(.primary)
                                .fontWeight(.bold)
                                .padding()
                            Text("Você ainda não possui alunos")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .fontWeight(.medium)
                        }
                        Spacer()
                        
                        Button {
                            //func para copiar o codigo?
                        } label: {
                            Text("Seu código: 1234")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 350, maxHeight: 52)
                                .background(Color(red: 0.65, green: 0.13, blue: 0.29))
                                .cornerRadius(50)
                        }
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .padding()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ZStack {
                                    //colocar um for each para buscar os alunos
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.white)
                                    VStack {
                                        //colocar foto do aluno
                                        Text("Nome do aluno")
                                    }
                                    
                                }
                            }
                            .padding()
                        }
                    }
                } else {
                    if isGroupsEmpty {
                        Spacer(minLength: 100)
                        ZStack {
                            Image(systemName: "person.3.fill")
                                .foregroundColor(Color(red: 0.65, green: 0.13, blue: 0.29))
                            Circle()
                                .fill(Color(red: 0.65, green: 0.13, blue: 0.29))
                                .opacity(0.3)
                                .frame(width: 50, height: 50, alignment: .center)
                                .padding()
                        }
                        VStack (spacing: -15){
                            Text("Sem grupos")
                                .font(.title3)
                                .foregroundColor(.primary)
                                .fontWeight(.bold)
                                .padding()
                            Text("Você ainda não possui grupos")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .fontWeight(.medium)
                        }
                        Spacer()
                    } else {
                        VStack {
                            //for each de cada grupo
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                //foto do grupo
                                HStack {
                                    //nome do grupo
                                    //quantidade de alunos
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Alunos")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        criarGrupo = true
                    }) {
                        Image(systemName: "person.2.badge.plus.fill")
                            .foregroundStyle(Color(red: 0.65, green: 0.13, blue: 0.29))
                            .background(Color.white)
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "person.fill.checkmark.and.xmark")
                            .foregroundStyle(Color(red: 0.65, green: 0.13, blue: 0.29))
                            .background(Color.white)
                    }
                }
                
            }
        }
        .sheet(isPresented: $criarGrupo) {
            CriarGrupoView()
        }
    }
}

#Preview {
    AlunosView()
}

