//
//  CriarTarefaView.swift
//  OsVigaristas
//
//  Created by Erika Hacimoto on 10/11/25.
//
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
    
    private var inputNameSection: some View {
        Section {
            TextField("Nome da Tarefa (Obrigatório)", text: $tarefaNome)
            TextField("Descrição (Opcional)", text: $tarefaDescricao)
        }
    }
    
    private var participantesSection: some View {
        Section {
            LabeledContent("Participantes") {
                NavigationLink(destination: AddGrupo(selectedUserID: $selectedUserID, grupos: grupos())) {
                    HStack{
                        Spacer()
                        if selectedUserID == nil {
                            Text("Nenhum")
                        } else {
                            if let grupoSelecionado = grupos().first(where: { $0.id == selectedUserID }) {
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
                    Button {
                        Task {
                            isSaving = true
                            defer { isSaving = false }
                            
                            guard let selectedID = selectedUserID,
                                  let selectedUser = participants.first(where: { $0.id == selectedID }) else { return }
                            
                            guard let currentUser = AuthService.shared.currentUser else {
                                throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No user loggoed in"])
                            }
                            let currentRef = CKRecord.Reference(recordID: currentUser.id, action: .none)
                            
                            let studentRef = CKRecord.Reference(recordID: selectedUser.id, action: .none)
                            
                            // Use TaskModel as required by PersistenceServices
                            let task = TaskModel(
                                title: tarefaNome,
                                description: tarefaDescricao,
                                student: [currentRef, studentRef],
                                startDate: selectedDateInit,
                                endDate: selectedDateEnd
                            )
                            do {
                                try await persistenceServices.createTask(task)
                                try? await Task.sleep(for: .seconds(1.5)) // espera CloudKit atualizar
                                await MainActor.run {
                                    onTarefaCriada?()
                                    numTask += 1
                                    dismiss()
                                }
                            } catch {
                                print("Erro ao criar grupo: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        Label("Adicionar", systemImage: "checkmark")
                    }
                    .disabled(tarefaNome.isEmpty || selectedUserID == nil)
                }
            }
        }
    }
}

#Preview {
    CriarTarefaView(numTask: .constant(0))
}



//import SwiftUI
//import CloudKit
//
//struct CriarTarefaView: View {
//    @State private var selectedItem: Int = 0
//    @State private var selectedDateInit = Date()
//    @State private var selectedDateEnd = Date()
//    @State private var tarefaNome: String = ""
//    @State private var tarefaDescricao: String = ""
//    @State private var moedas: Int = 5
//    @State private var selecao: UUID?
//    @Environment(\.dismiss) var dismiss
//    @Binding var numTask: Int
//    @EnvironmentObject var persistenceServices: PersistenceServices
//    @State private var isSaving = false
//    var onTarefaCriada: (() -> Void)?
//    @State private var participants: [UserModel] = []
//    @State private var selectedUserID: CKRecord.ID? = nil
//    
//    init(numTask: Binding<Int>) {
//        self._numTask = numTask
//    }
//    
//    var body: some View {
//        NavigationStack {
//            VStack() {
//                Form {
//                    Section {
//                        TextField("Nome da Tarefa (Obrigatório)", text: $tarefaNome)
//                        TextField("Descrição (Opcional)", text: $tarefaDescricao)
//                    }
//                    Section("Participantes") {
//                        Picker("Escolha um aluno", selection: $selectedUserID) {
//                            Text("Selecione...").tag(nil as CKRecord.ID?)
//                            
//                            ForEach(participants, id: \.id) { user in
//                                Text(user.name).tag(user.id as CKRecord.ID?)
//                            }
//                        }
//                    }
//                    Section {
//                        LabeledContent("Início") {
//                            DatePicker("", selection: $selectedDateInit)
//                                .datePickerStyle(.compact)
//                        }
//                        LabeledContent("Término") {
//                            DatePicker("", selection: $selectedDateEnd)
//                                .datePickerStyle(.compact)
//                        }
//                    }
//                }
//            }
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationTitle("Adicionar Tarefa")
//            .toolbar {
//                // If you want a cancel button, uncomment:
//                 ToolbarItem(placement: .cancellationAction) {
//                     Button {
//                         dismiss()
//                     } label: {
//                         Label("Cancelar", systemImage: "xmark")
//                     }
//                 }
//                ToolbarItem(placement: .confirmationAction) {
//                    Button {
//                        Task {
//                            isSaving = true
//                            defer { isSaving = false }
//                            
//                            guard let selectedID = selectedUserID,
//                                  let selectedUser = participants.first(where: { $0.id == selectedID }) else { return }
//                            
//                            let studentRef = CKRecord.Reference(recordID: selectedUser.id, action: .none)
//                            
//                            // Use TaskModel as required by PersistenceServices
//                            let task = TaskModel(
//                                title: tarefaNome,
//                                description: tarefaDescricao,
//                                student: studentRef,
//                                startDate: selectedDateInit,
//                                endDate: selectedDateEnd
//                            )
//                            do {
//                                try await persistenceServices.createTask(task)
//                                try? await Task.sleep(for: .seconds(1.5)) // espera CloudKit atualizar
//                                await MainActor.run {
//                                    onTarefaCriada?()
//                                    numTask += 1
//                                    dismiss()
//                                }
//                            } catch {
//                                print("Erro ao criar grupo: \(error.localizedDescription)")
//                            }
//                        }
//                    } label: {
//                        Label("Adicionar", systemImage: "checkmark")
//                    }
//                    .disabled(tarefaNome.isEmpty || selectedUserID == nil || isSaving)
//                }
//            }
//            // If needed, load participants automatically:
//             .task {
//                 do {
//                     participants = try await persistenceServices.fetchUserForTask()
//                     print("participantes carregados: ", participants.map(\.name))
//                 } catch {
//                     print("Erro ao carregar participantes: \(error.localizedDescription)")
//                 }
//             }
//        }
//    }
//}
//
//
//#Preview {
//    CriarTarefaView(numTask: .constant(0))
//}
