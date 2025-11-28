//
//  Desafio.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 27/10/25.
//

import Foundation
import CloudKit

// Os models não devem ser actor-isolated, mas sim os viewModels
//@MainActor
final class ChallengeModel: Identifiable, Equatable, Hashable {
    var id: CKRecord.ID
    
    // Tem alguem fazendo o desafio agora????
    var someoneIsDoingIt: Bool = false
    
    // Linkar audio com os alunos
    var studentAudios: [CKRecord.ID: URL]
    
    var generalAudio: URL?
    
    var group: CKRecord.Reference?
    var title: String
    var description: String
    var whichChallenge: Int // ver se vale a pena colocar nome
    var reward: Int
    var startDate: Date
    var endDate: Date

    init(whichChallenge: Int, title: String, description: String, group: CKRecord.Reference, reward: Int, startDate: Date, endDate: Date) {
        self.id = CKRecord.ID(recordName: UUID().uuidString)
        self.studentAudios = [:]
        self.generalAudio = nil
        self.group = group
        self.title = title
        self.description = description
        self.whichChallenge = whichChallenge
        self.reward = reward
        self.startDate = startDate
        self.endDate = endDate
    }
    
    //
    // To fetch from CloudKit
    init(from record: CKRecord) {
        self.id = record.recordID
        
        self.studentAudios = record["studentAudios"] as? [CKRecord.ID: URL] ?? [:]
        self.generalAudio = record["generalAudio"] as? URL ?? nil
        
        self.group = record["group"] as? CKRecord.Reference
        self.title = record["title"] as? String ?? ""
        self.description = record["description"] as? String ?? ""
        self.whichChallenge = record["whichChallenge"] as? Int ?? 0
        self.reward = record["reward"] as? Int ?? 0
        self.startDate = record["startDate"] as? Date ?? Date()
        self.endDate = record["endDate"] as? Date ?? Date()
        self.someoneIsDoingIt = record["someoneIsDoingIt"] as? Bool ?? false
    }
    
    static func == (lhs: ChallengeModel, rhs: ChallengeModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
