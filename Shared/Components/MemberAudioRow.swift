//
//  MemberAudioRow.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 01/12/25.
//

import SwiftUI


struct MemberAudioRow: View {
    let member: UserModel
    let audio: AudioRecordModel
    @StateObject var player = MiniPlayer()

    var body: some View {
        VStack(alignment: .leading) {
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
                }
                PlaybackWaveformView(progress: player.progress)
            }
        }
    }
}
