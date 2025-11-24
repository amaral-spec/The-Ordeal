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
    var body: some View {
        NavigationStack {
            
            Spacer()
            
            VStack { // Writing section
                
                TopPageInstructionView(instruction: """
                    Grave uma continuação de 
                    15 segundos para o audio abaixo
                    """)
                
                Spacer()
                
                AudioRepresentationView()
                    .padding(.trailing, 30)
                
                Spacer()
                
                PinkIconImageView()
                
                ImageMessageView(
                    title: "Grave o seu audio",
                    subtitle: "Faça milage"
                )
                
                Spacer()
                Spacer()
                
                RecordingButtonView(color: .accentColor)
            }
            .navigationTitle(Text("Encadeia"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Uncomment if needed
                /*
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", systemImage: "xmark") { }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("confirmar", systemImage: "checkmark") { }
                        .tint(Color("AccentColor"))
                }
                */
            }
        }
    }
}

#Preview {
    ReceivedAudioRecordChainedChallengeView()
}
