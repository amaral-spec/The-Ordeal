//
//  UserModel.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 29/10/25.
//

import Foundation
import CloudKit
import AuthenticationServices

//@MainActor
final class UserModel: Identifiable {
    var id: CKRecord.ID
    var creationDate: Date
    var name: String
    var email: String
    var isTeacher: Bool
    var streak: Int
    var points: Int
    var lastTask: TaskModel?
    var lastChallenge: ChallengeModel?
    var profileImageName: String?
    var profileImage: UIImage?
    
    init(credential: ASAuthorizationAppleIDCredential) {
        let userIdentifier = credential.user
        self.id = CKRecord.ID(recordName: userIdentifier)
        self.creationDate = Date()
        self.name = credential.fullName?.givenName ?? "Usuário Apple"
        self.email = credential.email ?? ""
        self.isTeacher = false
        self.streak = 0
        self.points = 0
        self.lastTask = nil
        self.lastChallenge = nil
    }
    
    // To fetch from CloudKit
    init(from record: CKRecord) {
        self.id = record.recordID
        self.creationDate = record.creationDate ?? Date()
        self.name = record["name"] as? String ?? ""
        self.email = record["email"] as? String ?? ""
        self.isTeacher = record["isTeacher"] as? Bool ?? false
        self.streak = record["streak"] as? Int ?? 0
        self.points = record["points"] as? Int ?? 0
        self.profileImageName = record["profileImageName"]

        // Converte CKAsset em UIImage
        if let asset = record["profileImage"] as? CKAsset,
           let url = asset.fileURL,
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            self.profileImage = image
        } else {
            self.profileImage = UIImage(named: "partitura")
        }
    }

    
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: "User", recordID: id)
        record["name"] = name as CKRecordValue
        record["email"] = email as CKRecordValue
        record["isTeacher"] = isTeacher as CKRecordValue
        record["streak"] = streak as CKRecordValue
        record["points"] = points as CKRecordValue
        return record
    }
}
