//
//  AudioRecordProtocol.swift
//  Dingo
//
//  Created by Ludivik de Paula on 02/12/25.
//

import CloudKit

protocol AudioRecordProtocol {
    var audioURL: URL { get }
    var userRef: CKRecord.Reference { get }
}
