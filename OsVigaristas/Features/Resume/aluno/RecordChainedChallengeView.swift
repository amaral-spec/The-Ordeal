//
//  RecordChainedChallengeView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI
import UIKit // For haptic feedback
import Combine
import AVFoundation

struct RecordChainedChallengeView: View {
    var body: some View {
        NavigationStack {
            
            Spacer()
            
            VStack { // Writing section
                
                TopPageInstructionView(instruction: "Toque algo de sua escolha por 15 segundos")
                
                Spacer()
                
                AudioRepresentationView()
                
                Spacer()
                
                RecordingButtonView(color: .accentColor)
            }
            .navigationTitle(Text("Encadeia"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", systemImage: "xmark") {
                        // dismiss()
                    }
                }
                /*
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
    RecordChainedChallengeView()
}
