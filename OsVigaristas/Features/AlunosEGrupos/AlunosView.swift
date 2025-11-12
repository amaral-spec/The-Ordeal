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
    
    //mock com os jsons
    
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

                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 10) {
                                // MARK: - Puxar do CloudKit
//                                ForEach([]) { aluno in
//                                    VStack {
//                                        Image(aluno.foto)
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: 90, height: 90)
//                                            .clipShape(Circle())
//                                        
//                                        Text(aluno.nome)
//                                            .font(.caption)
//                                            .foregroundColor(.primary)
//                                    }
//                                    .padding(6)
//                                    .background(.white)
//                                    .cornerRadius(10)
//                                    .shadow(radius: 1)
//                                }
                            }
                        }
                        .padding()
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
                        ScrollView {
                            VStack(spacing: 10) {
                                // MARK: - Puxar do CloudKit
//                                ForEach(dataVM.grupos) { grupo in
//                                    NavigationLink(destination: DetalheGrupoView(grupo: grupo)) {
//                                        HStack {
//                                            Image(grupo.foto)
//                                                .resizable()
//                                                .scaledToFill()
//                                                .frame(width: 60, height: 60)
//                                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                            
//                                            VStack(alignment: .leading) {
//                                                Text(grupo.nome)
//                                                    .font(.headline)
//                                                
//                                                Text("\(grupo.quantidadeAlunos) alunos")
//                                                    .font(.subheadline)
//                                                    .foregroundColor(.secondary)
//                                            }
//                                            
//                                            Spacer()
//                                        }
//                                        .padding()
//                                        .background(.white)
//                                        .cornerRadius(12)
//                                        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
//                                    }
//                                    .buttonStyle(.plain) // <-- opcional, remove highlight azul
//                                    
//                                }
                            }
                            .padding()
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

