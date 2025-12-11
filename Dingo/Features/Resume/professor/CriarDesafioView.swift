//
// CriarDesafioView.swift
// OsVigaristas
//
// Created by Erika Hacimoto on 10/11/25.
//
import SwiftUI
import CloudKit

struct CriarDesafioView: View {
    // ALTERAÇÃO 1: Inicializado com 1 para "Echo" já vir selecionado
    @State private var selectedChallengeType: Int = 1
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
    
    // ALTERAÇÃO 2: Propriedade computada para retornar a explicação
    var descricaoTipoDesafio: String {
        switch selectedChallengeType {
        case 1:
            return "O primeiro aluno irá gravar um sample para ser imitado pelos próximos alunos."
        case 2:
            return "O primeiro aluno irá gravar um sample, e os próximos alunos irão escutar os últimos 5 segundos e isso se seguirá em cadeia."
        default:
            return ""
        }
    }
    
    init(numChallenge: Binding<Int>) {
        self._numChallenge = numChallenge
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Tipo", selection: $selectedChallengeType) {
                        Text("Echo").tag(1)
                        Text("Encadeia").tag(2)
                    }
                    .pickerStyle(.segmented)
                    
                    // ALTERAÇÃO 2: Exibição da explicação dinâmica
                    Text(descricaoTipoDesafio)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 4)
                } header: {
                    Text("Tipo de Desafio")
                }
                
                Section {
                    TextField("Nome do Desafio (Obrigatório)", text: $desafioNome)
                    
                    TextField("Descrição (Opcional)", text: $desafioDescricao)
                } header: {
                    Text("Título & Descrição")
                }
                
                Section {
                    Picker("Escolha um grupo", selection: $selectedGroupID) {
                        Text("Selecione...").tag(nil as CKRecord.ID?)
                        ForEach(groups, id: \.id) { group in
                            Text(group.name).tag(group.id as CKRecord.ID?)
                        }
                    }
                    .pickerStyle(.navigationLink)
                } header: {
                    Text("Grupo")
                }
                
                Section {
                    DatePicker("Data de início", selection: $selectedDate)
                        .datePickerStyle(.compact)
                } footer: {
                    Text("A data de término será definida automaticamente para 1 semana após o início.")
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
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
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
                            
                            // Lógica de data mantida conforme o original (+ 7 dias)
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
                                generator.notificationOccurred(.error) // Mudei para .error aqui pois faz mais sentido no catch
                                
                                // Removes feedback after 2.0 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation {
                                        self.failedCreateChallenge = false
                                    }
                                    
                                    // Comentado para permitir que o usuário tente novamente sem fechar a tela
                                    // dismiss()
                                }
                            }
                            isSaving = false
                        }
                    } label: {
                        Label("Adicionar", systemImage: "checkmark")
                            .background(Color("BlueCard")) // Certifique-se que essa cor existe nos Assets
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
                    .background(Color("RedCard")) // Certifique-se que essa cor existe nos Assets
                    .cornerRadius(30)
                    .padding(.top, 40)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(duration: 0.4), value: failedCreateChallenge)
            }
        }
    }
}
