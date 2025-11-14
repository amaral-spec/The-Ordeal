//
//  CriarDesafioView 2.swift
//  OsVigaristas
//
//  Created by Erika Hacimoto on 10/11/25.
//

import SwiftUI
import CloudKit

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
    @EnvironmentObject var persistenceServices: PersistenceServices
    @State private var isSaving = false
    var onTarefaCriada: (() -> Void)?
    @State private var participants: [UserModel] = []
    @State private var selectedUserID: CKRecord.ID? = nil
    
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
                    Section("Participantes") {
                        Picker("Escolha um aluno", selection: $selectedUserID) {
                            ForEach(participants, id: \.id) { user in
                                Text(user.name).tag(user.id as CKRecord.ID?)
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
            .task {
                do {
                    participants = try await persistenceServices.fetchUserForTask()
                } catch {
                    print("Erro ao carregar participantes: \(error.localizedDescription)")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", systemImage: "xmark") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Adicionar", systemImage: "checkmark") {
                        Task {
                            isSaving = true
                            guard let selectedID = selectedUserID,
                                  let selectedUser = participants.first(where: { $0.id == selectedID }) else { return }
                        
                            let studentRef = CKRecord.Reference(recordID: selectedUser.id, action: .none)
                            
                            let task = TaskModel(
                                title: tarefaNome,
                                description: tarefaDescricao,
                                student: studentRef,
                                startDate: selectedDateInit,
                                endDate: selectedDateEnd
                            )
                            do {
                                try await persistenceServices.createTask(task)
                                try? await Task.sleep(for: .seconds(1.5)) // espera CloudKit atualizar
                                await MainActor.run {
                                    onTarefaCriada?()
                                    dismiss()
                                }
                            } catch {
                                print("Erro ao criar grupo: \(error.localizedDescription)")
                            }
                            isSaving = false
                        }

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
//
//#Preview {
//    CriarTarefaView(numTask: .constant(0))
//}
