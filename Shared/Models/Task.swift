//
//  Atividades.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 27/10/25.
//

import Foundation
import CloudKit


//@MainActor
final class TaskModel:  Identifiable, Equatable, Hashable  {
    var id: CKRecord.ID
    var studentAudio: [URL]?
    var student: CKRecord.Reference
    var title: String
    var description: String
    var reward: Int
    var startDate: Date
    var endDate: Date
    
    
    init(title: String, description: String, student: CKRecord.Reference, startDate: Date, endDate: Date){
        self.id = CKRecord.ID(recordName: UUID().uuidString)
        self.studentAudio = nil
        self.student = student
        self.title = title
        self.description = description
        self.reward = 0
        self.startDate = startDate
        self.endDate = endDate
    }
    
    // To fetch from CloudKit
    init(from record: CKRecord) {
        self.id = record.recordID
        self.studentAudio = record["studentAudio"] as? [URL] ?? nil
        self.student = record["student"] as! CKRecord.Reference
        self.title = record["title"] as? String ?? ""
        self.description = record["description"] as? String ?? ""
        self.reward = record["reward"] as? Int ?? 0
        self.startDate = record["startDate"] as? Date ?? Date()
        self.endDate = record["endDate"] as? Date ?? Date()
    }
    
    static func == (lhs: TaskModel, rhs: TaskModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
