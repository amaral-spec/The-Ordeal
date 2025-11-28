//
//  AudioRecordModel.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 28/11/25.
//


import CloudKit
import Foundation

final class AudioRecordModel: Identifiable, Hashable {
    
    let id: CKRecord.ID
    let audioURL: URL
    let challengeRef: CKRecord.Reference
    let userRef: CKRecord.Reference
    let createdAt: Date
    
    init(
        id: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString),
        audioURL: URL,
        challengeID: CKRecord.ID,
        userID: CKRecord.ID,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.audioURL = audioURL
        self.challengeRef = CKRecord.Reference(recordID: challengeID, action: .none)
        self.userRef = CKRecord.Reference(recordID: userID, action: .none)
        self.createdAt = createdAt
    }
    
    /// Convert this model to a CKRecord for saving into CloudKit
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "AudioRecord", recordID: id)
        
        record["audio"] = CKAsset(fileURL: audioURL)
        record["challenge"] = challengeRef
        record["user"] = userRef
        record["createdAt"] = createdAt as CKRecordValue
        
        return record
    }
    
    /// Initializer to parse a CKRecord fetched from CloudKit
    convenience init?(from record: CKRecord) {
        guard
            let asset = record["audio"] as? CKAsset,
            let audioURL = asset.fileURL,
            let challengeRef = record["challenge"] as? CKRecord.Reference,
            let userRef = record["user"] as? CKRecord.Reference,
            let createdAt = record["createdAt"] as? Date
        else {
            return nil
        }
        
        self.init(
            id: record.recordID,
            audioURL: audioURL,
            challengeID: challengeRef.recordID,
            userID: userRef.recordID,
            createdAt: createdAt
        )
    }
    
    static func ==(lhs: AudioRecordModel, rhs: AudioRecordModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
