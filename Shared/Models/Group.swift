//
//  Grupos.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 28/10/25.
//

import Foundation
import CloudKit
import SwiftUI

@MainActor
final class GroupModel: Identifiable {
    var id: CKRecord.ID
    var name: String
    var members: [CKRecord.Reference]
    var image: UIImage?
    
    init(name: String, image: UIImage? = nil) {
        self.id = CKRecord.ID(recordName: UUID().uuidString)
        self.name = name
        self.members = []
        self.image = image
    }
}
