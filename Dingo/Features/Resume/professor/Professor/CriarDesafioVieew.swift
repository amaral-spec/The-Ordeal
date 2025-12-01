////
////  CriarGrupoView.swift
////  OsVigaristas
////
////  Created by Erika Hacimoto on 10/11/25.
////
//
//import SwiftUI
//
//private let grupos = [
//    Grupo(nome: "JJ"),
//    Grupo(nome: "ALIEN"),
//    Grupo(nome: "Maria Maria")
//]
//
//struct CriarDesafioView: View {
//    @State private var selectedItem: Int = 0
//    @State private var selectedDate = Date()
//    @State private var desafioNome: String = ""
//    @State private var desafioDescricao: String = ""
//    @State private var moedas: Int = 5
//    @State private var selecao: UUID?
//    @Environment(\.dismiss) var dismiss
//    @Binding var numChallenge: Int
//    @EnvironmentObject var persistenceServices: PersistenceServices
//    @State private var isSaving = false
//    var onDesafioCriado: (() -> Void)?
//
//    
//    init(numChallenge: Binding<Int>) {
//        self._numChallenge = numChallenge
//    }
//    
//    var body: some View {
//        NavigationStack {
//            VStack() {
//                Form {
//                    Section {
//                        LabeledContent("Tipo de Desafio") {
//                            Picker("", selection: $selectedItem) {
//                                Text("Personalizado").tag(0)
//                                Text("Echo").tag(1)
//                                Text("Encadeia").tag(2)
//                            }
//                        }
//                    }
//                    Section {
//                        TextField("Nome do Desafio (Obrigatório)", text: $desafioNome)
//                        TextField("Descrição (Opcional)", text: $desafioDescricao)
//                    }
//                    Section {
//                        LabeledContent("Participantes") {
//                            NavigationLink(destination: List(grupos, selection: $selecao) { grupo in Text(grupo.nome) }
//                            ) {
//                                HStack{
//                                    Spacer()
//                                    if (selecao == nil) { Text("Nenhum") }
//                                    ForEach(grupos) { grupo in
//                                        if (grupo.id == selecao) {
//                                            Text(grupo.nome)
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    Section {
//                        LabeledContent("Recompensa: \(moedas) moedas") {
//                            Stepper("Recompensa: \(moedas) moedas", value: $moedas, in: 0...50)
//                                .labelsHidden()
//                        }
//                    }
//                    Section {
//                        LabeledContent("Data de início") {
//                            DatePicker("", selection: $selectedDate)
//                                .datePickerStyle(.compact)
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Adicionar Desafio")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancelar", systemImage: "xmark") {
//                        dismiss()
//                    }
//                }
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Adicionar", systemImage: "checkmark") {
////                        Task {
////                            isSaving = true
////                            let group = GroupModel(name: grupoNome)
////                            do {
////                                try await persistenceServices.createGroup(group)
////                                try? await Task.sleep(for: .seconds(1.5)) // espera CloudKit atualizar
////                                await MainActor.run {
////                                    onGrupoCriado?()
////                                    dismiss()
////                                }
////                            } catch {
////                                print("Erro ao criar grupo: \(error.localizedDescription)")
////                            }
////                            isSaving = false
////                        }
//
//                        numChallenge += 1
//                        dismiss()
//                    }
//                    .disabled(desafioNome.isEmpty)
//                    .disabled(selecao == nil)
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    CriarDesafioView(numChallenge: .constant(0))
//}
