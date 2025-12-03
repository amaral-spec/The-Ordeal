//
//  WaitingChainedChallengeView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI

struct WaitingChainedChallengeView: View {

    @EnvironmentObject var doChallengeVM: DoChallengeViewModel
    @EnvironmentObject var persistenceServices: PersistenceServices
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
        .task {
            guard let challenge = doChallengeVM.challengeM else { return }

            // 1. Verifica se está livre
            let locked = await persistenceServices.isChallengeLocked(challengeID: challenge.id)

            if locked == false {
                // 2. Desafio está livre → iniciar sessão
                await doChallengeVM.startChallenge()

                // 3. Verificar se há respostas anteriores
                let hasNoStudentAudios = 

                if hasNoStudentAudios {
                    // Caso NÃO tenha respostas → vai para InitialChained
                    onNavigation(.initialChained)
                } else {
                    // Caso JÁ tenha respostas → vai para ReceivedAudio
                    onNavigation(.receiveChained)
                }

            } else {
                print("Desafio ocupado, aguardando...")
            }
        }

        .navigationTitle("Encadeia")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}
