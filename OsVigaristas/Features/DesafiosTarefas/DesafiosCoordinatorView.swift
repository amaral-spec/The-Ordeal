//
//  OsVigaristas
//
//  Created by Erika Hacimoto on 04/11/25.
//

import SwiftUI

struct Grupo: Identifiable, Hashable {
    let id = UUID()
    let nome: String
}

struct HomeView: View {
    @State private var criarDesafio = false
    @State private var criarTarefa = false
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
            VStack (spacing: -15) {
                if selectedMode == Mode.Desafio {
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
                    } else {
                        ScrollView{
                            VStack {
                                Spacer()
                                ForEach(0..<numChallenge, id: \.self) {
                                    i in OldCard(index: i)
                                    Spacer(minLength: 20)
                                }
                            }
                            .frame(width: 405)
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
                    } else {
                        ScrollView{
                            VStack {
                                Spacer()
                                ForEach(0..<numTask, id: \.self) {
                                    i in OldCard(index: i)
                                    Spacer(minLength: 20)
                                }
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
                        if selectedMode == Mode.Desafio {
                            criarDesafio = true
                        } else {
                            criarTarefa = true
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $criarDesafio) {
            CriarDesafioView(numChallenge: $numChallenge)
        }
        .sheet(isPresented: $criarTarefa) {
            CriarTarefaView(numTask: $numTask)
        }
    }
}

#Preview {
    HomeView()
}
//struct DesafiosCoordinatorView: View {
//    enum Route: Hashable {
//        case list
//        case detalhe(Desafio)
//    }
//
//    @State private var path = [Route]()
//    let isProfessor: Bool
//
//    var body: some View {
//
//        Text("Desafio")
//
//        NavigationStack(path: $path) {
//            DesafiosListView(viewModel: makeViewModel())
//                .navigationDestination(for: Route.self) { route in
//                    switch route {
//                    case .detalhe(let desafio):
//                        TarefaDetalheView(desafio: desafio)
//                    default:
//                        EmptyView()
//                    }
//                }
//        }
//    }
//
//    private func makeViewModel() -> DesafiosListViewModel {
//        userType == .professor
//            ? ProfessorDesafiosViewModel()
//            : AlunoDesafiosViewModel()
//    }
//}
