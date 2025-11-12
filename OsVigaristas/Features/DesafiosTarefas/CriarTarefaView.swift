//
//  CriarDesafioView 2.swift
//  OsVigaristas
//
//  Created by Erika Hacimoto on 10/11/25.
//

import SwiftUI

private let grupos = [
    Grupo(nome: "JJ"),
    Grupo(nome: "ALIEN"),
    Grupo(nome: "Maria Maria")
]

struct CriarTarefaView: View {
    @State private var selectedItem: Int = 0
    @State private var selectedDateInit = Date()
    @State private var selectedDateEnd = Date()
    @State private var tarefaNome: String = ""
    @State private var tarefaDescricao: String = ""
    @State private var moedas: Int = 5
    @State private var selecao: UUID?
    @Environment(\.dismiss) var dismiss
    @Binding var numTask: Int
    
    init(numTask: Binding<Int>) {
        self._numTask = numTask
    }
    
    var body: some View {
        NavigationStack {
            VStack() {
                Form {
                    Section {
                        TextField("Nome da Tarefa (Obrigatório)", text: $tarefaNome)
                        TextField("Descrição (Opcional)", text: $tarefaDescricao)
                    }
                    Section {
                        LabeledContent("Participantes") {
                            NavigationLink(destination: List(grupos, selection: $selecao) { grupo in Text(grupo.nome) }
                            ) {
                                HStack{
                                    Spacer()
                                    if (selecao == nil) { Text("Nenhum") }
                                    ForEach(grupos) { grupo in
                                        if (grupo.id == selecao) {
                                            Text(grupo.nome)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Section {
                        LabeledContent("Início") {
                            DatePicker("", selection: $selectedDateInit)
                                .datePickerStyle(.compact)
                        }
                        LabeledContent("Término") {
                            DatePicker("", selection: $selectedDateEnd)
                                .datePickerStyle(.compact)
                        }
                    }
                }
            }
            .navigationTitle("Adicionar Tarefa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", systemImage: "xmark") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Adicionar", systemImage: "checkmark") {
                        numTask += 1
                        dismiss()
                    }
                    .disabled(tarefaNome.isEmpty)
                    .disabled(selecao == nil)
                }
            }
        }
    }
}

#Preview {
    CriarTarefaView(numTask: .constant(0))
}
