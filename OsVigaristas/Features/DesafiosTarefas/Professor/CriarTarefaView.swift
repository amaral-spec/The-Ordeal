//
//  CriarDesafioView 2.swift
//  OsVigaristas
//
//  Created by Erika Hacimoto on 10/11/25.
//

import SwiftUI
import CloudKit

@MainActor
private func grupos() -> [GroupModel] {
    return [
        GroupModel(name: "JJ", image: nil),
        GroupModel(name: "ALIEN", image: nil),
        GroupModel(name: "Maria Maria", image: nil)
    ]
}

struct CriarTarefaView: View {
    @State private var selectedItem: Int = 0
    @State private var selectedDateInit = Date()
    @State private var selectedDateEnd = Date()
    @State private var tarefaNome: String = ""
    @State private var tarefaDescricao: String = ""
    @State private var moedas: Int = 5
    @State private var selecao: CKRecord.ID?
    @Environment(\.dismiss) var dismiss
    @Binding var numTask: Int
    
    init(numTask: Binding<Int>) {
        self._numTask = numTask
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    inputNameSection
                    participantesSection
                    dataSection
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
    
    private var inputNameSection: some View {
        Section {
            TextField("Nome da Tarefa (Obrigatório)", text: $tarefaNome)
            TextField("Descrição (Opcional)", text: $tarefaDescricao)
        }
    }
    
    private var participantesSection: some View {
        Section {
            LabeledContent("Participantes") {
                NavigationLink(destination: AddGrupo(selecao: $selecao, grupos: grupos())) {
                    HStack{
                        Spacer()
                        if selecao == nil {
                            Text("Nenhum")
                        } else {
                            if let grupoSelecionado = grupos().first(where: { $0.id == selecao }) {
                                Text(grupoSelecionado.name)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var dataSection: some View {
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

#Preview {
    CriarTarefaView(numTask: .constant(0))
}
