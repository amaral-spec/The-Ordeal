//
//  WaitingChainedChallengeView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI

struct WaitingChainedChallengeView: View {

    
    let onNavigation: (DoChallengeCoordinatorView.Route) -> Void

    var body: some View {
        VStack {
            Spacer()
            PinkWaitingIconImageView(iconName: "clock.arrow.trianglehead.counterclockwise.rotate.90")

            ImageMessageView(
                title: "Em espera",
                subtitle: "Outra pessoas está gravando,\nespere o desafio estar livre\npara começar"
            )
            Spacer()
        }
        .onAppear() {
            
        }
        .navigationTitle("Encadeia")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
}
