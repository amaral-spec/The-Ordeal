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
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    TextField("Nome do grupo", text: $grupoNome)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .fill(.gray.opacity(0.2))
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
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isSaving {
                        ProgressView()
                    } else {
                        Button("Adicionar", systemImage: "checkmark") {
                            Task {
                                isSaving = true
                                let group = GroupModel(name: grupoNome)
                                do {
                                    try await persistenceServices.createGroup(group)
                                    try? await Task.sleep(for: .seconds(1.5)) // espera CloudKit atualizar
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
                        .disabled(grupoNome.isEmpty)
                    }
                }
            }
        }
    }
}

#Preview {
    CriarGrupoView()
}
