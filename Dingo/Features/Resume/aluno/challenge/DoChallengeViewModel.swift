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


final class DoChallengeViewModel: ObservableObject {
    
    @Published var challengeM: ChallengeModel?
    
    @Published var alreadyREC: Bool = false
    
    @Published var recordings: [URL] = []
    
    @Published var challengeSessionRecordID: CKRecord.ID?

    
    private let persistenceServices: PersistenceServices
    
    init(persistenceServices: PersistenceServices, challengeM: ChallengeModel) {
        self.persistenceServices = persistenceServices
        self.challengeM = challengeM
    }

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
    
    func fetchChallenge(ckrecord_id: CKRecord.ID) async {
        do {
            let fetched = try await persistenceServices.fetchChallenge(recordID: ckrecord_id)
            await MainActor.run {
                self.challengeM = fetched
            }
        } catch {
            // You can log or surface the error if desired
            print("Failed to fetch challenge: \(error)")
        }
    }
    
    func startChallenge() async {
        guard let challenge = self.challengeM else { return }
        guard let user = await AuthService.shared.currentUser else { return }

        do {
            let sessionID = try await persistenceServices.startChallengeSession(
                challengeID: challenge.id,
                userID: user.id
            )
            
            await MainActor.run {
                self.challengeSessionRecordID = sessionID
            }

            // Start heartbeat
            startHeartbeat(sessionID: sessionID)

        } catch {
            print("Failed to start session: \(error)")
        }
    }

    
    func outChallenge() async {
        stopHeartbeat()
        
        guard let sessionID = challengeSessionRecordID else { return }

        do {
            try await persistenceServices.deleteChallengeSession(sessionID: sessionID)
        } catch {
            print("Failed to end session: \(error)")
        }
    }

    
    private var heartbeatTimer: Timer?

    func startHeartbeat(sessionID: CKRecord.ID) {
        heartbeatTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            Task { try? await self.persistenceServices.updateChallengeSession(sessionID: sessionID) }
        }
    }

    func stopHeartbeat() {
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
    }

    func submitStudentAudio(url: URL) async {
        guard let challenge = challengeM else { return }
        guard let user = await AuthService.shared.currentUser else { return }
        
        do {
            try await persistenceServices.saveAudioRecordChallenge(
                challengeID: challenge.id,
                userID: user.id,
                audioURL: url
            )
            print("Audio enviado com sucesso!")
        } catch {
            print("Erro ao enviar áudio: \(error)")
        }
    }


}
