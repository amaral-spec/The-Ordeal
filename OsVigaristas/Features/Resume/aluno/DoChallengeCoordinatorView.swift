//
//  MakeChallengeCoordinator.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 19/11/25.
//

import SwiftUI

struct DoChallengeCoordinatorView: View {
    enum Route: Hashable {
        case waitingChained
        case initialChained
        case receiveChained
        case recordChained
    }
    
    @EnvironmentObject private var persistenceServices: PersistenceServices
    @State private var path: [Route] = []
    @StateObject var DoChallengeVM: DoChallengeViewModel = DoChallengeViewModel()
    
    var body: some View {
        NavigationStack {
            WaitingChainedChallengeView() { route in
                path.append(route)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .waitingChained:
                    EmptyView()
                case .initialChained:
                    EmptyView()
                case .recordChained:
                    EmptyView()
                case .receiveChained:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    // Preview simples: NavigationStack opcional, sem navegação de destino.
    let services = PersistenceServices()
    let vm = ResumeViewModel(persistenceServices: services, isTeacher: true)
    
    NavigationStack {
        ResumeView(resumeVM: vm) { _ in
            // onNavigate vazio no preview
        }
        .navigationTitle("Resumo")
        .toolbarTitleDisplayMode(.inlineLarge)
    }
}
