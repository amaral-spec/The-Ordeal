//
//  CriarDesafioView 2.swift
//  OsVigaristas
//
//  Created by Erika Hacimoto on 10/11/25.
//

import SwiftUI

struct CriarTarefaView: View {
    @State private var tarefaNome: String = ""
    @State private var tarefaDescricao: String = ""
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
                        TextField("Nome do Desafio", text: $tarefaNome)
                        TextField("Descrição (Opcional)", text: $tarefaDescricao)
                    }
                    Section {
                        LabeledContent("Participantes") {
                     
                        }
                    }
                    Section {
                        LabeledContent("Início") {
                     
                        }
                        LabeledContent("Término") {
                     
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
                }
            }
        }
    }
}

#Preview {
    CriarTarefaView(numTask: .constant(0))
}
