//
//  InicioDesafioEncadeiaView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI

struct InitialChainedChallengeView: View {
    
    let onNavigation: (DoChallengeCoordinatorView.Route) -> Void
    
    var body: some View {
        VStack{//Escrita
            TopPageInstructionView(instruction: "Toque algo de sua escolha por 15 segundos")
            Spacer()
            PinkIconImageView()
            ImageMessageView(title: "Grave o seu audio", subtitle: "Faça milage")
            Spacer()
            Spacer()
            Button {
                onNavigation(.recordChained)
            } label: {
                RecordingButtonView(color: .accentColor)
            }
        }
        .navigationTitle(Text("Encadeia"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
