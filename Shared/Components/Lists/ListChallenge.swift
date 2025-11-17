//
//  ListaDesafios.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 14/11/25.
//

import SwiftUI
import CloudKit

struct ListChallenge: View {
    @EnvironmentObject var resumeVM: ResumeViewModel
    
    let challengeList: [ChallengeModel]
    let onTap: (ChallengeModel) -> Void

    var body: some View {
        ScrollView {
            ForEach(challengeList) { challenge in
                Button {
                    onTap(challenge)
                } label: {
                    ChallengeRow(challenge: challenge)
                        .environmentObject(resumeVM)
                }
                .buttonStyle(.plain)

                Spacer(minLength: 20)
            }
        }
    }
}

private struct ChallengeRow: View {
    @EnvironmentObject var resumeVM: ResumeViewModel
    let challenge: ChallengeModel
    
    var body: some View {
        Group {
            if let groupRef = challenge.group,
               let group = resumeVM.groupsByID[groupRef.recordID] {
                Card(name: challenge.title,
                     quantity: group.members.count,
                     grupo: group.name)
            } else {
                // Placeholder while loading the group
                Card(name: challenge.title,
                     quantity: 0,
                     grupo: "Carregando...")
                    .redacted(reason: .placeholder)
            }
        }
        .task {
            await ensureGroupLoaded()
        }
    }
    
    @MainActor
    private func ensureGroupLoaded() async {
        guard let groupRef = challenge.group else { return }
        // If not cached, fetch and cache it
        if resumeVM.groupsByID[groupRef.recordID] == nil {
            do {
                let group = try await resumeVM.carregarGrupo(reference: groupRef)
                // Update cache on main actor
                resumeVM.groupsByID[groupRef.recordID] = group
            } catch {
                // Optionally handle error (log or set a failed placeholder state)
                print("Erro ao carregar grupo: \(error.localizedDescription)")
            }
        }
    }
}

