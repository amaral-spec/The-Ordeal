//
//  CriarGrupoView.swift
//  OsVigaristas
//
//  Created by Erika Hacimoto on 10/11/25.
//

import SwiftUI

struct CriarDesafioView: View {
    @State private var desafioNome: String = ""
    @State private var desafioDescricao: String = ""
    @State private var moedas: Int = 0
    @Environment(\.dismiss) var dismiss
    @Binding var numChallenge: Int
    
    init(numChallenge: Binding<Int>) {
        self._numChallenge = numChallenge
    }
    
    var body: some View {
        NavigationStack {
            VStack() {
                Form {
                    Section {
                        LabeledContent("Tipo de Desafio") {
                     
                        }
                    }
                    Section {
                        TextField("Nome do Desafio", text: $desafioNome)
                        TextField("Descrição (Opcional)", text: $desafioDescricao)
                    }
                    Section {
                        LabeledContent("Participantes") {
                     
                        }
                    }
                    Section {
                        LabeledContent("Recompensa: \(moedas) moedas") {
                     
                        }
                    }
                    Section {
                        LabeledContent("Início") {
                     
                        }
                    }
                }
            }
            .navigationTitle("Adicionar Desafio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", systemImage: "xmark") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Adicionar", systemImage: "checkmark") {
                        numChallenge += 1
                        dismiss()
                    }
                    .disabled(desafioNome.isEmpty)
                }
            }
        }
    }
}

#Preview {
    CriarDesafioView(numChallenge: .constant(0))
}
