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
            IconImageView(nomeIcone: "clock.arrow.trianglehead.counterclockwise.rotate.90")

            ImageMessageView(
                title: "Em espera",
                subtitle: "Outra pessoas está gravando,\nespere o desafio estar livre\npara começar"
            )
            Spacer()
        }
        .onAppear() {
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                
                let integerRandom = Int.random(in: 0..<2)
                
                onNavigation(.initialChained)
                
//                if (integerRandom == 1) {
//                    onNavigation(.initialChained)
//                } else {
//                    onNavigation(.receiveChained)
//                }
                
            }
        }
        .navigationTitle("Encadeia")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}
