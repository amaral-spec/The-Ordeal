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
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var path: [Route] = []
    
    @State private var showCancelAlert: Bool = false
    @State private var showConfirmAlert: Bool = false
    
    @StateObject private var doChallengeVM = DoChallengeViewModel()
    
    @State private var currentRoute: Route = .waitingChained

    private var cancelToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Cancelar", systemImage: "xmark") {
                showCancelAlert = true
            }
        }
    }
    
    private var confirmToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showConfirmAlert = true
            } label: {
                Label("Confirmar", systemImage: "checkmark")
            }
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            screen(for: .waitingChained)
                .navigationDestination(for: Route.self) { route in
                    screen(for: route)
                }
        }
        .alert("Cancelar desafio?", isPresented: $showCancelAlert) {
            Button("Manter", role: .cancel) { }
            Button("Cancelar desafio", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Tem certeza que deseja cancelar? Seu progresso atual será descartado.")
        }
        .alert("Enviar Desafio?", isPresented: $showConfirmAlert) {
            if #available(iOS 26.0, *) {
                Button("Finalizar", role: .confirm) { dismiss() }
            } else {
                Button("Finalizar") { dismiss() }
            }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text("Tem certeza que deseja enviar? Não será possível enviar novamente.")
        }
        .environmentObject(doChallengeVM)
    }
    
    @ViewBuilder
    private func screen(for route: Route) -> some View {
        switch route {
        case .waitingChained:
            WaitingChainedChallengeView { next in
                path.append(next)
            }
            .toolbar { cancelToolbar }
            .navigationBarBackButtonHidden(true)
            
        case .initialChained:
            InitialChainedChallengeView { next in
                path.append(next)
            }
            .toolbar { cancelToolbar }
            .navigationBarBackButtonHidden(true)
            
        case .receiveChained:
            ReceivedAudioRecordChainedChallengeView { next in
                path.append(next)
            }
            .toolbar { cancelToolbar }
            .navigationBarBackButtonHidden(true)

        case .recordChained:
            RecordChainedChallengeView { next in
                path.append(next)
            }
            .toolbar {
                cancelToolbar
                confirmToolbar
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
