//
//  GroupSelector.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 24/11/25.
//

import SwiftUI
import CloudKit

struct GroupSelector: View {
    let groups: [GroupModel]
    @Binding var selectedGroups: Set<CKRecord.ID>
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groups, id: \.id) { group in
                    HStack {
                        Text(group.name)
                        Spacer()
                        
                        Button {
                            if selectedGroups.contains(group.id) {
                                selectedGroups.remove(group.id)
                            } else {
                                selectedGroups.insert(group.id)
                            }
                        } label: {
                            Image(systemName:
                                    selectedGroups.contains(group.id)
                                  ? "checkmark.circle.fill"
                                  : "circle"
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Selecionar Grupos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Adicionar", systemImage: "checkmark")
                    }
                }
            }
        }
    }
}
