//
//  ChallengeMakeViewModel.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 19/11/25.
//

import SwiftUI
import CloudKit

@MainActor
final class DoChallengeViewModel: ObservableObject, Identifiable {
    @Published var challenge: ChallengeModel?
    
    init() {
        
    }
}
