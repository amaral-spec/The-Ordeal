//
//  AddGrupo.swift
//  OsVigaristas
//
//  Created by Erika Hacimoto on 13/11/25.
//

//struct Grupo: Identifiable, Hashable {
//    let id = UUID()
//    let nome: String
//}

import SwiftUI
import CloudKit

struct AddGrupo: View {
//    @Binding var selecao: UUID?
    @Binding var selecao: CKRecord.ID?
//    let grupos: [Grupo]
    let grupos: [GroupModel]
    @State private var searchText = ""
    
    var gruposFiltrados: [GroupModel] {
        if searchText.isEmpty {
            return grupos
        } else {
            return grupos.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private func isSelected(_ grupo: GroupModel) -> Bool {
        guard let selecao = selecao else { return false }
        return grupo.id == selecao
    }
    
    var body: some View {
        List(gruposFiltrados) { grupo in
            HStack {
//                Text(grupo.nome)
//                Spacer()
//                if grupo.id == selecao {
//                    Image(systemName: "checkmark")
//                        .foregroundColor(.accentColor)
                if let image = grupo.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "person.2")
                                .foregroundColor(.gray)
                        )
                }
                
                VStack(alignment: .leading) {
                    Text(grupo.name)
                        .font(.headline)
                    Text("\(grupo.members.count) membros")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected(grupo) {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                        .font(.headline)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if isSelected(grupo) {
                    selecao = nil
                } else {
                    selecao = grupo.id
                }
            }
        }
        .navigationTitle("Selecionar Grupo")
        .searchable(text: $searchText, prompt: "Buscar grupos...")
    }
}

#Preview {
    NavigationStack {
        AddGrupo(selecao: .constant(nil), grupos: [GroupModel(name: "JJ"), GroupModel(name: "ALIEN"), GroupModel(name: "Maria Maria")])
    }
}
