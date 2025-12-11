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

struct RecordFromInitialTaskView: View {

    @EnvironmentObject var doTaskVM: DoTaskViewModel
    @EnvironmentObject var player: MiniPlayer
    
    // Use a computed property so we can safely access the environment object.
    private var firstURL: URL? {
        doTaskVM.recordings.first
    }
    
    let onNavigation: (DoTaskCoordinatorView.Route) -> Void

    var body: some View {
        VStack {
            TopPageInstructionView(instruction: "Toque algo de sua escolha por 15 segundos")

            Spacer()
            
            HStack {
                Button {
                    if player.playingURL == firstURL && player.isPlaying {
                        player.pause()
                    } else {
                        player.play(firstURL)
                    }
                } label: {
                    Image(systemName: (player.playingURL == firstURL && player.isPlaying) ? "pause.fill" : "play.fill")
                }
                .buttonStyle(.plain)
                .disabled(firstURL == nil)
                
                PlaybackWaveformView(progress: player.progress)
            }
            .padding(32) 
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                    .padding(16)
            )


            Spacer()

            Button {
                onNavigation(.initialTask)
            } label: {
                Text("Regravar Audio")
                    .tint(.black)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("GreenCardBackground"))
        }
        .onAppear {
            doTaskVM.recordings = doTaskVM.recordingsList()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
