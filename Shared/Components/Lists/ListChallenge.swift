//
//  ListaDesafios.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 14/11/25.
//

import SwiftUI

struct ListChallenge: View {
    @EnvironmentObject var resumeVM: ResumeViewModel
    
    let challengeList: [ChallengeModel]
    let onTap: (ChallengeModel) -> Void

    var body: some View {
        ScrollView {
            ForEach(challengeList) { challenge in
                Button {
                    onTap(challenge)
                } label: {
                    if let groupRef = challenge.group,
                       let group = resumeVM.groupsByID[groupRef.recordID] {
                        Card(name: challenge.title, quantity: group.members.count)
                    } else {
                        Card(name: challenge.title, quantity: 1203)
                    }
                }
                .buttonStyle(.plain)

                Spacer(minLength: 20)
            }
        }
    }
}
