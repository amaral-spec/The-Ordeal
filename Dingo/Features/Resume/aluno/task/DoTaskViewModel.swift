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


final class DoTaskViewModel: ObservableObject {
    
    @Published var taskM: TaskModel?
    @Published var recordings: [URL] = []
    @Published var isCompleted: Bool = false
    
    private let persistenceServices: PersistenceServices
    
    init(persistenceServices: PersistenceServices, taskM: TaskModel? = nil) {
            self.persistenceServices = persistenceServices
            self.taskM = taskM
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
    
    func fetchTask(ckrecord_id: CKRecord.ID) async {
        do {
            let fetched = try await persistenceServices.fetchTask(recordID: ckrecord_id)
            await MainActor.run {
                self.taskM = fetched
            }
        } catch {
            // You can log or surface the error if desired
            print("Failed to fetch challenge: \(error)")
        }
    }

    func submitStudentAudio(url: URL) async {
        guard let task = taskM else { return }
        guard let user = await AuthService.shared.currentUser else { return }
        
        do {
            try await persistenceServices.saveAudioRecordTask(
                taskID: task.id,
                userID: user.id,
                audioURL: url
            )
            print("Audio enviado com sucesso!")
        } catch {
            print("Erro ao enviar áudio: \(error)")
        }
    }


}
