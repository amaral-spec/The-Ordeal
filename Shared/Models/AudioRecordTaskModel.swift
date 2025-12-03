//
//  AudioRecordModel.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 28/11/25.
//


import CloudKit
import Foundation

final class AudioRecordTaskModel: Identifiable, Hashable, AudioRecordProtocol {
    
    let id: CKRecord.ID
    let audioURL: URL
    let taskRef: CKRecord.Reference
    let userRef: CKRecord.Reference
    let createdAt: Date
    
    init(
        id: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString),
        audioURL: URL,
        taskID: CKRecord.ID,
        userID: CKRecord.ID,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.audioURL = audioURL
        self.taskRef = CKRecord.Reference(recordID: taskID, action: .none)
        self.userRef = CKRecord.Reference(recordID: userID, action: .none)
        self.createdAt = createdAt
    }
    
    /// Convert this model to a CKRecord for saving into CloudKit
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "AudioRecordTask", recordID: id)
        
        record["audio"] = CKAsset(fileURL: audioURL)
        record["task"] = taskRef
        record["user"] = userRef
        record["createdAt"] = createdAt as CKRecordValue
        
        return record
    }
    
    /// Initializer to parse a CKRecord fetched from CloudKit
    convenience init?(from record: CKRecord) {
        guard
            let asset = record["audio"] as? CKAsset,
            let audioURL = asset.fileURL,
            let taskRef = record["task"] as? CKRecord.Reference,
            let userRef = record["user"] as? CKRecord.Reference,
            let createdAt = record["createdAt"] as? Date
        else {
            return nil
        }
        
        self.init(
            id: record.recordID,
            audioURL: audioURL,
            taskID: taskRef.recordID,
            userID: userRef.recordID,
            createdAt: createdAt
        )
    }
    
    static func ==(lhs: AudioRecordTaskModel, rhs: AudioRecordTaskModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
