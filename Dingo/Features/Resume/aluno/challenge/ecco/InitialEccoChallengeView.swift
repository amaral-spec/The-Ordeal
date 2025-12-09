//
//  InicioDesafioEncadeiaView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI

struct InitialEccoChallengeView: View {
    
    @EnvironmentObject var doChallengeVM: DoChallengeViewModel
    @EnvironmentObject var rec: MiniRecorder
    let onNavigation: (DoChallengeCoordinatorView.Route) -> Void
    
    var body: some View {
        VStack{//Escrita
            TopPageInstructionView(instruction: "Toque algo de sua escolha")
            Spacer()
            IconImageView(nomeIcone: "waveform")
            ImageMessageView(title: "Grave o seu áudio", subtitle: "")
            MultiBarVisualizerView(values: rec.meterHistory, barCount: 24)
                .frame(height: 54)
                .padding(.horizontal)
            Spacer()
            Spacer()
            Button {
                if rec.isRecording {
                    rec.stop()
                    onNavigation(.recordEcco)
                } else {
                    rec.start()
                }
            } label: {
                RecordingButtonView(isRecording: rec.isRecording, color: Color("BlueCard"))
            }
        }
        .navigationTitle(Text("Ecco"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
