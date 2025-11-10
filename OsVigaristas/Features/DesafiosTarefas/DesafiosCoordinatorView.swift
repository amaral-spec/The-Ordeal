//
//  DesafiosCoordinatorView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 04/11/25.
//

import SwiftUI

struct DesafiosCoordinatorView: View {
    enum Route: Hashable {
        case list
        case detalhe(Desafio)
    }

    @State private var path = [Route]()
    let isProfessor: Bool

    var body: some View {
        
        Text("Desafio")
        
//        NavigationStack(path: $path) {
//            DesafiosListView(viewModel: makeViewModel())
//                .navigationDestination(for: Route.self) { route in
//                    switch route {
//                    case .detalhe(let desafio):
//                        TarefaDetalheView(desafio: desafio)
//                    default:
//                        EmptyView()
//                    }
//                }
//        }
    }

//    private func makeViewModel() -> DesafiosListViewModel {
//        userType == .professor
//            ? ProfessorDesafiosViewModel()
//            : AlunoDesafiosViewModel()
//    }
}
