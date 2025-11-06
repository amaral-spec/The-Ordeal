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

struct AlunosView: View {
    @State private var isStudentsEmpty = true
    @State private var isGroupsEmpty = true
    @State private var selectedMode = Mode.Alunos
    
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
                                .fill(Color.accentColor)
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
                    }
                } else {
                    if isGroupsEmpty {
                        Spacer(minLength: 100)
                        ZStack {
                            Image(systemName: "person.3.fill")
                                .foregroundColor(Color(red: 0.65, green: 0.13, blue: 0.29))
                            Circle()
                                .fill(Color.accentColor)
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
                    }
                }
            }
            .navigationTitle("Alunos")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Adicionar", systemImage: "person.2.badge.plus.fill") {
                        
                    }
                    .tint(Color(red: 0.65, green: 0.13, blue: 0.29))
                }
            }
        }
    }
}

#Preview {
    AlunosView()
}

