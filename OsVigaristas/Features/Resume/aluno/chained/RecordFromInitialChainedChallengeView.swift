//
//  RecordChainedChallengeView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI
import UIKit
import Combine
import AVFoundation

struct RecordFromInitialChainedChallengeView: View {

    @EnvironmentObject var doChallengeVM: DoChallengeViewModel
    @EnvironmentObject var player: MiniPlayer
    
    // Use a computed property so we can safely access the environment object.
    private var lastURL: URL? {
        doChallengeVM.recordings.first
    }
    
    let onNavigation: (DoChallengeCoordinatorView.Route) -> Void

    var body: some View {
        VStack {
            TopPageInstructionView(instruction: "Toque algo de sua escolha por 15 segundos")

            Spacer()
            
            HStack {
                Button {
                    if player.playingURL == lastURL && player.isPlaying {
                        player.pause()
                    } else {
                        player.play(lastURL)
                    }
                } label: {
                    Image(systemName: (player.playingURL == lastURL && player.isPlaying) ? "pause.fill" : "play.fill")
                }
                .buttonStyle(.plain)
                .disabled(lastURL == nil)
                
                PlaybackWaveformView(progress: player.progress)
            }
            .padding()

            Spacer()

            Button {
                onNavigation(.initialChained)
            } label: {
                Text("Regravar Audio")
                    .tint(Color("BlueChallenge"))
            }
        }
        .onAppear {
            doChallengeVM.recordings = doChallengeVM.recordingsList()
        }
        .navigationTitle("Em cadeia")
        .navigationBarTitleDisplayMode(.inline)
    }
}
