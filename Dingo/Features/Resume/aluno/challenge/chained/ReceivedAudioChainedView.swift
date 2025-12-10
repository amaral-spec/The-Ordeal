//
//  ReceivedAudioRecordChainedChallengeView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI
import UIKit // For haptic feedback
import Combine
import AVFoundation

struct ReceivedAudioChainedView: View {
    
    
    @EnvironmentObject var doChallengeVM: DoChallengeViewModel
    @EnvironmentObject var player: MiniPlayer
    @EnvironmentObject var rec: MiniRecorder
    @State private var urlToBeCompleted: URL? = nil
    
    
    let onNavigation: (DoChallengeCoordinatorView.Route) -> Void
    
    
    // Use a computed property so we can safely access the environment object.
    private var firstURL: URL? {
        doChallengeVM.recordings.first
    }

    var body: some View {
        VStack { // Writing section
            TopPageInstructionView(instruction: """
                    Grave uma continuação de 
                    para o audio abaixo
                    """)
            Spacer()
            HStack {
                Button {
                    if player.playingURL == urlToBeCompleted && player.isPlaying {
                        player.pause()
                    } else {
                        player.play(urlToBeCompleted)
                    }
                } label: {
                    Image(systemName: (player.playingURL == urlToBeCompleted && player.isPlaying) ? "pause.fill" : "play.fill")
                }
                .buttonStyle(.plain)
                .disabled(urlToBeCompleted == nil)
                
                PlaybackWaveformView(progress: player.progress)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                    .padding(16)
            )
            Spacer()
            IconImageView(nomeIcone: "waveform")
            ImageMessageView(
                title: "Grave o seu áudio",
                subtitle: "Faça história"
            )
            Spacer()
            MultiBarVisualizerView(values: rec.meterHistory, barCount: 24)
                .frame(height: 54)
                .padding(.horizontal)
            Spacer()
            Button {
                if rec.isRecording {
                    rec.stop()
                    onNavigation(.recordChained)
                } else {
                    rec.start()
                }
            } label: {
                RecordingButtonView(isRecording: rec.isRecording)
            }
        }
        .task {
            if let url = await doChallengeVM.getLastAudioToBeCompleted() {
                urlToBeCompleted = url
            }
        }
        .navigationTitle(Text("Encadeia"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

#Preview {
    ReceivedAudioChainedView() {_ in 
        print("Navegue")
    }
}
