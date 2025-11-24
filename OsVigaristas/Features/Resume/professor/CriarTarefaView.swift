//
//  CriarTarefaView.swift
//  OsVigaristas
//
//  Created by Erika Hacimoto on 10/11/25.
//
//

import SwiftUI
import CloudKit

//@MainActor
private let groups = [
    GroupModel(name: "JJ", image: nil),
    GroupModel(name: "ALIEN", image: nil),
    GroupModel(name: "Maria Maria", image: nil)
]

struct CriarTarefaView: View {
    @State private var selectedItem: Int = 0
    @State private var selectedDateInit = Date()
    @State private var selectedDateEnd = Date()
    @State private var tarefaNome: String = ""
    @State private var tarefaDescricao: String = ""
    @State private var moedas: Int = 5
    @Environment(\.dismiss) var dismiss
    @Binding var numTask: Int
    @EnvironmentObject var persistenceServices: PersistenceServices
    @State private var isSaving = false
    var onTarefaCriada: (() -> Void)?
    @State private var selecao: CKRecord.ID? = nil
        
    init(numTask: Binding<Int>) {
        self._numTask = numTask
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
                NavigationLink(destination: List(groups, selection: $selecao) { group in Text(group.name) } ) {
                    HStack{
                        Spacer()
                        if selecao == nil {
                            Text("Nenhum")
                        } else {
                            if let selectedGroup = groups.first(where: { $0.id == selecao } ) {
                                Text(selectedGroup.name)
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
                        dismiss()
                    }
                    .disabled(tarefaNome.isEmpty || selecao == nil)
                }
            }
        }
    }
}

#Preview {
    CriarTarefaView(numTask: .constant(0))
}
