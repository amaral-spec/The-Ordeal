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

struct ReceivedAudioRecordChainedChallengeView: View {
    
    @StateObject private var rec = MiniRecorder()
    @EnvironmentObject var doChallengeVM: DoChallengeViewModel
    
    let onNavigation: (DoChallengeCoordinatorView.Route) -> Void
    
    var body: some View {
        VStack { // Writing section
            TopPageInstructionView(instruction: """
                    Grave uma continuação de 
                    15 segundos para o audio abaixo
                    """)
            Spacer()
            AudioRepresentationView()
                .padding(.trailing, 30)
            Spacer()
            IconImageView(nomeIcone: "waveform")
            ImageMessageView(
                title: "Grave o seu audio",
                subtitle: "Faça milage"
            )
            Spacer()
            Spacer()
            Button {
                
            } label: {
                RecordingButtonView( isRecording: rec.isRecording)
            }
        }
        .navigationTitle(Text("Em cadeia"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

#Preview {
    ReceivedAudioRecordChainedChallengeView() {_ in 
        print("Navegue")
    }
}
