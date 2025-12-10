//
//  CriarGrupoView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 10/11/25.
//

import SwiftUI
import CloudKit

struct CriarGrupoView: View {
    var onGrupoCriado: (() -> Void)?
    @State private var grupoNome: String = ""
    @Environment(\.dismiss) var dismiss
    @State private var isSaving = false
    @EnvironmentObject var persistenceServices: PersistenceServices
    
    // 1. Estado para controlar o popup
    @State private var showDiscardAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    TextField("Nome do grupo", text: $grupoNome)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .fill(.white)
                        )
                        .padding()
                    
                    Spacer()
                }
            }
            .navigationTitle("Criar grupo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", systemImage: "xmark") {
                        // 2. Lógica: Só pergunta se tiver algo escrito
                        if !grupoNome.trimmingCharacters(in: .whitespaces).isEmpty {
                            showDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    }
                    .tint(Color.black)
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isSaving {
                        ProgressView()
                    } else {
                        // Apliquei o estilo de bolinha que você gostou antes
                        Button {
                            salvarGrupo()
                        } label: {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .disabled(grupoNome.isEmpty)
                        .buttonStyle(.borderedProminent)
                        .tint(Color("BlueCard"))
                    }
                }
            }
            // 3. O Alerta de confirmação
            .alert("Descartar novo grupo?", isPresented: $showDiscardAlert) {
                Button("Cancelar", role: .cancel) { } // Fica na tela
                
                Button("Descartar", role: .destructive) {
                    dismiss() // Fecha a tela
                }
            } message: {
                Text("Se você sair agora, o nome do grupo será perdido.")
            }
            .background(Color(.secondarySystemBackground))
        }
    }
    
    // Extraí a função de salvar para ficar mais limpo
    private func salvarGrupo() {
        Task {
            isSaving = true
            let group = GroupModel(name: grupoNome)
            do {
                try await persistenceServices.createGroup(group)
                try? await Task.sleep(for: .seconds(1.5))
                await MainActor.run {
                    onGrupoCriado?()
                    dismiss()
                }
            } catch {
                print("Erro ao criar grupo: \(error.localizedDescription)")
            }
            isSaving = false
        }
    }
}

#Preview {
    CriarGrupoView()
}
