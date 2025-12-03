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
            TopPageInstructionView(instruction: "Toque algo de sua escolha por 15 segundos")
            Spacer()
            IconImageView(nomeIcone: "waveform")
            ImageMessageView(title: "Grave o seu audio", subtitle: "")
            MultiBarVisualizerView(values: rec.meterHistory, barCount: 24)
                .frame(height: 54)
                .padding(.horizontal)
            Spacer()
            Spacer()
            Button {
                if rec.isRecording {
                    rec.stop()
                    onNavigation(.recordChained)
                } else {
                    rec.start()
                }
            } label: {
                RecordingButtonView(isRecording: rec.isRecording, color: Color("GreenCard"))
            }
        }
        .navigationTitle(Text("Encadeia"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
