//
//  AddGrupo.swift
//  OsVigaristas
//
//  Created by Erika Hacimoto on 13/11/25.
//

import SwiftUI
import CloudKit

struct AddGrupo: View {
    @State private var select: UUID?
    @Binding var selectedUserID: CKRecord.ID?
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
        guard let selectedUserID = selectedUserID else { return false }
        return grupo.id == selectedUserID
    }
    
    var body: some View {
        List(gruposFiltrados, selection: $select) { grupo in
            HStack {
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
//            .onTapGesture {
//                
////                selectedUserID = grupo.recordID
//                if isSelected(grupo) {
//                    selectedUserID = nil
//                } else {
//                    selectedUserID = grupo.id
//                }
//            }
            .onTapGesture {
                print("Tapped grupo: \(grupo.name)")
                print("Grupo ID: \(grupo.id)")
                print("Currently selected: \(String(describing: selectedUserID))")
                
                if isSelected(grupo) {
                    selectedUserID = nil
                    print("Deselected grupo")
                } else {
                    selectedUserID = grupo.id
                    print("Selected grupo: \(grupo.name)")
                }
            }
        }
        .navigationTitle("Selecionar Grupo")
        .searchable(text: $searchText, prompt: "Buscar grupos...")
    }
}

#Preview {
    NavigationStack {
        AddGrupo(selectedUserID: .constant(nil), grupos: [GroupModel(name: "JJ"), GroupModel(name: "ALIEN"), GroupModel(name: "Maria Maria")])
    }
}
