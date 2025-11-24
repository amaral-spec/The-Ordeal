//
//  CriarDesafioView.swift
//  OsVigaristas
//
//  Created by Erika Hacimoto on 10/11/25.
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
    @State private var groups: [GroupModel] = []
    @State private var showGroupSelector = false
    @State private var selectedGroups: Set<CKRecord.ID> = []
    
    var onDesafioCriado: (() -> Void)?
    
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
                
                Section("Grupos") {
                    Button {
                        showGroupSelector = true
                    } label: {
                        HStack {
                            Text("Selecionar grupos")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.black)
                    }
                    
                    if !selectedGroups.isEmpty {
                        ForEach(selectedGroups.compactMap { id in
                            groups.first(where: { $0.id == id })
                        }, id: \.id) { group in
                            Text(group.name)
                        }
                    } else {
                        Text("Nenhum grupo selecionado")
                            .foregroundColor(.secondary)
                    }
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
                    Button { dismiss() } label: {
                        Label("Cancelar", systemImage: "xmark")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        
                        Task {
                            isSaving = true
                            
                            for groupID in selectedGroups {
                                if let group = groups.first(where: { $0.id == groupID }) {
                                    
                                    let groupRef = CKRecord.Reference(
                                        recordID: group.id,
                                        action: .none
                                    )
                                    
                                    let challenge = ChallengeModel(
                                        whichChallenge: selectedChallengeType,
                                        title: desafioNome,
                                        description: desafioDescricao,
                                        group: groupRef,
                                        reward: moedas,
                                        startDate: selectedDate,
                                        endDate: selectedDate
                                    )
                                    
                                    do {
                                        try await persistenceServices.createChallenge(challenge)
                                    } catch {
                                        print("Erro ao criar desafio para grupo \(group.name):", error.localizedDescription)
                                    }
                                }
                            }
                            
                            await MainActor.run {
                                numChallenge += 1
                                onDesafioCriado?()
                                dismiss()
                            }
                            
                            isSaving = false
                        }
                        
                    } label: {
                        Label("Adicionar", systemImage: "checkmark")
                    }
                    .disabled(desafioNome.isEmpty || selectedGroups.isEmpty || isSaving)
                }
            }
        }
        .sheet(isPresented: $showGroupSelector) {
            GroupSelector(groups: groups, selectedGroups: $selectedGroups)
        }
    }
    
}

