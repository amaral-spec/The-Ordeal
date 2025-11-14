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
    var groupCode: String
    var joinSolicitations: [CKRecord.Reference]?
    
    init(name: String, image: UIImage? = nil) {
        self.id = CKRecord.ID(recordName: UUID().uuidString)
        self.name = name
        self.members = []
        self.image = image
        self.groupCode = String(format: "%06d", Int.random(in: 0...999_999))
        self.joinSolicitations = nil
    }
    
    // Initializer from reference
    init(from record: CKRecord) {
        self.id = record.recordID
        self.name = record["name"] as? String ?? ""
        self.members = record["members"] as? [CKRecord.Reference] ?? []
        self.groupCode = record["groupCode"] as? String ?? "000000"
        self.joinSolicitations = nil
        
        if let asset = record["image"] as? CKAsset,
           let fileURL = asset.fileURL,
           let imageData = try? Data(contentsOf: fileURL),
           let uiImage = UIImage(data: imageData) {
            self.image = uiImage
        } else {
            self.image = nil
        }
    }

}
