//
//  RecordChainedChallengeView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI
import UIKit
import Combine
import AVFoundation

struct RecordChainedChallengeView: View {

    let onNavigation: (DoChallengeCoordinatorView.Route) -> Void

    var body: some View {
        VStack {
            TopPageInstructionView(instruction: "Toque algo de sua escolha por 15 segundos")

            Spacer()
            AudioRepresentationView()
            Spacer()

            Button {
                onNavigation(.recordChained)
            } label: {
                RecordingButtonView(color: .accentColor)
            }
        }
        .navigationTitle("Em cadeia")
        .navigationBarTitleDisplayMode(.inline)
    }
}
