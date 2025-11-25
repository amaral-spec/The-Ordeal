//
//  ChallengeMakeViewModel.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 19/11/25.
//

import SwiftUI
import CloudKit
import Combine
import AVFoundation


final class DoChallengeViewModel: ObservableObject, Identifiable {
    @Published var challenge: ChallengeModel?
    @Published var alreadyREC: Bool = false
    
    @Published var recordings: [URL] = []

    func recordingsList() -> [URL] {
        // Locate the Recordings folder.
        let dir = try? FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("Recordings", isDirectory: true)
        
        // List files in the folder, or return empty array if folder missing or error.
        guard let dir, let files = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil) else { return [] }
        
        // Filter for .m4a audio files and sort descending by filename (newest first).
        return files.filter { $0.pathExtension == "m4a" }.sorted { $0.lastPathComponent > $1.lastPathComponent }
    }
}
