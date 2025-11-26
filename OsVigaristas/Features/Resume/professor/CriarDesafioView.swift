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
    init(numChallenge: Binding<Int>) {
        self._numChallenge = numChallenge
    }
    var body: some View {
        NavigationStack {
            Form {
                Section("Tipo de Desafio") {
                    Picker("Tipo", selection: $selectedChallengeType) {
                        Text("Personalizado").tag(0)
                        Text("Echo").tag(1)
                        Text("Encadeia").tag(2)
                    }
                    .pickerStyle(.segmented)
                }
                Section {
                    TextField("Nome do Desafio (Obrigatório)", text: $desafioNome)
                    TextField("Descrição (Opcional)", text: $desafioDescricao)
                }
                Section("Grupo") {
                    Picker("Escolha um grupo", selection: $selectedGroupID) {
                        Text("Selecione...").tag(nil as CKRecord.ID?)
                        ForEach(groups, id: \.id) { group in
                            Text(group.name).tag(group.id as CKRecord.ID?)
                        }
                    }
                    .pickerStyle(.menu)
                }
                Section {
                    LabeledContent("Recompensa: \(moedas) moedas") {
                        Stepper("", value: $moedas, in: 0...50)
                            .labelsHidden()
                    }
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
                                reward: moedas,
                                startDate: selectedDate,
                                endDate: Calendar.current.date(byAdding: .day, value: 7, to: selectedDate)!
                            )
                            do {
                                try await persistenceServices.createChallenge(challenge)
                                try? await Task.sleep(for: .seconds(1.0))
                                await MainActor.run {
                                    numChallenge += 1
                                    onDesafioCriado?()
                                    dismiss()
                                }
                            } catch {
                                print("Erro ao criar desafio:", error.localizedDescription)
                            }
                            isSaving = false
                        }
                    } label: {
                        Label("Adicionar", systemImage: "checkmark")
                    }
                    .disabled(desafioNome.isEmpty || selectedGroupID == nil || isSaving)
                }
            }
        }
    }
}
