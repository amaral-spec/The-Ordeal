//
//  WaitingChainedChallengeView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI

struct WaitingChainedChallengeView: View {
    var body: some View {
        NavigationStack {
            
            VStack { 
                Spacer()
                PinkWaitingIconImageView(iconName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                
                ImageMessageView(
                    title: "Em espera",
                    subtitle: "Outra pessoas está gravando,\nespere o desafio estar livre\npara começar"
                )
                
                Spacer()
            }
            .navigationTitle(Text("Encadeia"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", systemImage: "xmark") {
                        // dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    WaitingChainedChallengeView()
}
