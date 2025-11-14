//
//  DesafiosCoordinatorView 2.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 14/11/25.
//

import SwiftUI
import Foundation

struct DesafiosCoordinatorView: View {
    enum Route: Hashable {
        case list
        case detalhe(ChallengeModel)
    }

    @State private var path = [Route]()
    let isProfessor: Bool

    var body: some View {

        Text("Desafio")

        NavigationStack(path: $path) {
            if 
        }
    }

    // TODO: Uncomment and provide implementations for these types, or adjust as needed.
    // private func makeViewModel() -> DesafiosListViewModel {
    //     isProfessor
    //         ? ProfessorDesafiosViewModel()
    //         : AlunoDesafiosViewModel()
    // }
}
