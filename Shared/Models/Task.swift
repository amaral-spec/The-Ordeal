//
//  Atividades.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 27/10/25.
//

import Foundation
import CloudKit


@MainActor
final class TaskModel: Identifiable {
    var id: CKRecord.ID
    var studentAudio: [URL]
    var student: CKRecord.Reference
    var title: String
    var description: String
    var reward: Int
    var startDate: Date
    var endDate: Date
    
    
    init(title: String, description: String, student: CKRecord.Reference, startDate: Date, endDate: Date){
        self.id = CKRecord.ID(recordName: UUID().uuidString)
        self.studentAudio = []
        self.student = student
        self.title = title
        self.description = description
        self.reward = 0
        self.startDate = startDate
        self.endDate = endDate
    }
}
