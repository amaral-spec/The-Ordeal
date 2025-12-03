//
//  MemberAudioRow.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 01/12/25.
//

import SwiftUI


struct MemberAudioRow: View {
    let member: UserModel
    let audio: any AudioRecordProtocol

    @StateObject private var player = MiniPlayer()

    var body: some View {
        HStack {
            Button {
                if player.playingURL == audio.audioURL && player.isPlaying {
                    player.pause()
                } else {
                    player.play(audio.audioURL)
                }
            } label: {
                Image(systemName: (player.playingURL == audio.audioURL && player.isPlaying)
                      ? "pause.fill" : "play.fill")
                    .foregroundColor(.primary)
            }
            .buttonStyle(.plain)

            PlaybackWaveformView(
                progress: (player.playingURL == audio.audioURL ? player.progress : 0)
            )
            .frame(height: 24)

            Spacer()
        }
        .padding(.leading, 20)
        .padding(.vertical, 4)
    }
}
