//
//  Grupos.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 28/10/25.
//

import Foundation
import CloudKit


@MainActor
final class GroupModel: Identifiable {
    var id: CKRecord.ID
    var name: String
    var members: [CKRecord.Reference]
    
    init(name: String) {
        self.id = CKRecord.ID(recordName: UUID().uuidString)
        self.name = name
        self.members = []
    }
}
