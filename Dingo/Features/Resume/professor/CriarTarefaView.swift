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
    @State private var didCreateTask: Bool = false
    @State private var failedCreateTask: Bool = false
    
    init(numTask: Binding<Int>) {
        self._numTask = numTask
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Nome da Tarefa (Obrigatório)", text: $tarefaNome)
                        TextField("Descrição (Opcional)", text: $tarefaDescricao)
                    }
                    Section("Participantes") {
                        Picker("Escolha um aluno", selection: $selectedUserID) {
                            Text("Selecione...").tag(nil as CKRecord.ID?)
                            
                            ForEach(participants, id: \.id) { user in
                                Text(user.name).tag(user.id as CKRecord.ID?)
                            }
                        }
                        .pickerStyle(.navigationLink)
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Adicionar Tarefa")
            .toolbar {
                // If you want a cancel button, uncomment:
                 ToolbarItem(placement: .cancellationAction) {
                     Button {
                         dismiss()
                     } label: {
                         Image( systemName: "xmark")
                             .foregroundStyle(.black)
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
                                    
                                    withAnimation {
                                        didCreateTask = true
                                    }
                                    
                                    // Haptics
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                    
                                    // Removes feedback after 2.0 seconds
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        withAnimation {
                                            self.didCreateTask = false
                                        }
                                        dismiss()
                                    }
                                }
                            } catch {
                                print("Erro ao criar grupo: \(error.localizedDescription)")
                                
                                withAnimation {
                                    failedCreateTask = true
                                }
                                
                                // Haptics
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                                
                                // Removes feedback after 2.0 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation {
                                        self.failedCreateTask = false
                                    }
                                    
                                    dismiss()
                                }
                            }
                        }
                    } label: {
                        Label("Adicionar", systemImage: "checkmark")
                    }
                    .tint(Color("GreenCard"))
                    .disabled(tarefaNome.isEmpty || selectedUserID == nil || isSaving)
                }
            }
            // If needed, load participants automatically:
             .task {
                 do {
                     participants = try await persistenceServices.fetchUserForTask()
                     print("participantes carregados: ", participants.map(\.name))
                 } catch {
                     print("Erro ao carregar participantes: \(error.localizedDescription)")
                 }
             }
             .overlay(alignment: .top) {
                 if didCreateTask {
                     Text("Tarefa criada!")
                         .font(.headline)
                         .padding(.vertical, 10)
                         .padding(.horizontal, 20)
                         .background(Color("BlueCard"))
                         .cornerRadius(30)
                         .padding(.top, 40)
                         .transition(.move(edge: .top).combined(with: .opacity))
                         .animation(.spring(duration: 0.4), value: didCreateTask)
                 } else if failedCreateTask {
                     Text("Erro ao criar tarefa")
                         .font(.headline)
                         .padding(.vertical, 10)
                         .padding(.horizontal, 20)
                         .background(Color("RedCard"))
                         .cornerRadius(30)
                         .padding(.top, 40)
                         .transition(.move(edge: .top).combined(with: .opacity))
                         .animation(.spring(duration: 0.4), value: failedCreateTask)
                 }
             }
        }
    }
}
//
//#Preview {
//    CriarTarefaView(numTask: .constant(0))
//}
