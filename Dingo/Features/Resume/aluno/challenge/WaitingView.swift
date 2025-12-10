//
//  WaitingChainedChallengeView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI

struct WaitingView: View {

    @EnvironmentObject var doChallengeVM: DoChallengeViewModel
    @EnvironmentObject var persistenceServices: PersistenceServices
    let onNavigation: (DoChallengeCoordinatorView.Route) -> Void
    
    private var title: String { doChallengeVM.challengeM?.whichChallenge == 1 ? "Ecco" : "Encadeia" }
    
    var body: some View {
        VStack {
            Spacer()
            IconImageView(nomeIcone: "clock.arrow.trianglehead.counterclockwise.rotate.90")

            ImageMessageView(
                title: "Em espera",
                subtitle: "Outra pessoa está gravando,\nespere o desafio estar livre\npara começar"
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
                let hasNoStudentAudios = await doChallengeVM.carregarAudios(challengeID: challenge.id).isEmpty

                if hasNoStudentAudios {
                    // Caso NÃO tenha respostas → vai para InitialChained
                    onNavigation(.initial)
                } else {
                    // Caso JÁ tenha respostas → vai para ReceivedAudio
                    onNavigation(.receive)
                }

            } else {
                print("Desafio ocupado, aguardando...")
            }
        }

        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
}
