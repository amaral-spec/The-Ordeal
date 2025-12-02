//
// CriarDesafioView.swift
// OsVigaristas
//
// Created by Erika Hacimoto on 10/11/25.
//
import SwiftUI
import CloudKit
struct CriarDesafioView: View {
    @State private var selectedChallengeType: Int = 0
    @State private var selectedDate = Date()
    @State private var desafioNome: String = ""
    @State private var desafioDescricao: String = ""
    @State private var moedas: Int = 5
    @Environment(\.dismiss) var dismiss
    @Binding var numChallenge: Int
    @EnvironmentObject var persistenceServices: PersistenceServices
    @State private var isSaving = false
    var onDesafioCriado: (() -> Void)?
    @State private var groups: [GroupModel] = []
    @State private var selectedGroupID: CKRecord.ID? = nil
    @State private var didCreateChallenge: Bool = false
    @State private var failedCreateChallenge: Bool = false
    
    
    init(numChallenge: Binding<Int>) {
        self._numChallenge = numChallenge
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Tipo de Desafio") {
                    Picker("Tipo", selection: $selectedChallengeType) {
                        Text("Echo").tag(1)
                        Text("Encadeia").tag(2)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    TextField("Nome do Desafio (Obrigatório)", text: $desafioNome)
                    
                    // TODO: Pegar descrição baseado no tipo de desafio
                    TextField("Descrição (Opcional)", text: $desafioDescricao)
                }
                Section("Grupo") {
                    Picker("Escolha um grupo", selection: $selectedGroupID) {
                        Text("Selecione...").tag(nil as CKRecord.ID?)
                        ForEach(groups, id: \.id) { group in
                            Text(group.name).tag(group.id as CKRecord.ID?)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                Section {
                    DatePicker("Data de início", selection: $selectedDate)
                        .datePickerStyle(.compact)
                }
            }
            .navigationTitle("Adicionar Desafio")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                do {
                    groups = try await persistenceServices.fetchAllGroups()
                } catch {
                    print("Erro ao carregar grupos:", error.localizedDescription)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Cancelar", systemImage: "xmark")
                            .foregroundStyle(Color("BlueCard"))
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            guard let selectedID = selectedGroupID,
                                  let group = groups.first(where: { $0.id == selectedID }) else {
                                return
                            }
                            isSaving = true
                            let groupRef = CKRecord.Reference(recordID: group.id, action: .none)
                            let challenge = ChallengeModel(
                                whichChallenge: selectedChallengeType,
                                title: desafioNome,
                                description: desafioDescricao,
                                group: groupRef,
                                reward: 0,
                                startDate: selectedDate,
                                endDate: Calendar.current.date(byAdding: .day, value: 7, to: selectedDate)!
                            )
                            do {
                                try await persistenceServices.createChallenge(challenge)
                                try? await Task.sleep(for: .seconds(1.0))
                                await MainActor.run {
                                    numChallenge += 1
                                    onDesafioCriado?()
                                    
                                    withAnimation {
                                        didCreateChallenge = true
                                    }
                                    
                                    // Haptics
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        withAnimation {
                                            self.didCreateChallenge = false
                                        }
                                        dismiss()
                                    }
                                }
                            } catch {
                                print("Erro ao criar desafio:", error.localizedDescription)
                                
                                withAnimation {
                                    failedCreateChallenge = true
                                }
                                
                                // Haptics
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                                
                                // Removes feedback after 2.0 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation {
                                        self.failedCreateChallenge = false
                                    }
                                    
                                    dismiss()
                                }
                            }
                            isSaving = false
                        }
                    } label: {
                        Label("Adicionar", systemImage: "checkmark")
                            .background(Color("BlueCard"))
                    }
                    .disabled(desafioNome.isEmpty || selectedGroupID == nil || isSaving)
                }
            }
        }
        .overlay(alignment: .top) {
            if didCreateChallenge {
                Text("Desafio criado!")
                    .font(.headline)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color("BlueCard"))
                    .cornerRadius(30)
                    .padding(.top, 40)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(duration: 0.4), value: didCreateChallenge)
            } else if failedCreateChallenge {
                Text("Erro ao criar desafio")
                    .font(.headline)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color("RedCard"))
                    .cornerRadius(30)
                    .padding(.top, 40)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(duration: 0.4), value: failedCreateChallenge)
            }
        }
    }
}
