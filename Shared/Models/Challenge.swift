//
//  Desafio.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 27/10/25.
//

import Foundation
import CloudKit


@MainActor
final class ChallengeModel: Identifiable {
    var id: CKRecord.ID
    var studentAudios: [URL]
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
        self.studentAudios = []
        self.generalAudio = nil
        self.group = group
        self.title = title
        self.description = description
        self.whichChallenge = whichChallenge
        self.reward = reward
        self.startDate = startDate
        self.endDate = endDate
    }
}
