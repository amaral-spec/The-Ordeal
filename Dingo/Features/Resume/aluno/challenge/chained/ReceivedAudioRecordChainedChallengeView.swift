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
                    para o audio abaixo
                    """)
            Spacer()
            
            Spacer()
            IconImageView(nomeIcone: "waveform")
            ImageMessageView(
                title: "Grave o seu áudio",
                subtitle: "Faça milagre"
            )
            Spacer()
            Spacer()
            Button {
                
            } label: {
                RecordingButtonView( isRecording: rec.isRecording)
            }
        }
        .navigationTitle(Text("Encadeia"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

#Preview {
    ReceivedAudioRecordChainedChallengeView() {_ in 
        print("Navegue")
    }
}
