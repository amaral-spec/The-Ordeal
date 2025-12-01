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
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var persistenceServices: PersistenceServices
    
    @State private var path: [Route] = [.waitingChained]
    
    @State private var showCancelAlert: Bool = false
    @State private var showConfirmAlert: Bool = false
    
    @StateObject private var doChallengeVM: DoChallengeViewModel
    @StateObject private var rec = MiniRecorder()
    @StateObject private var player = MiniPlayer()
    
    @State private var currentRoute: Route = .waitingChained
    @State private var micDenied = false


    init(challengeM: ChallengeModel) {
        _doChallengeVM = StateObject(wrappedValue: DoChallengeViewModel(persistenceServices: PersistenceServices.shared, challengeM: challengeM))
    }

    var body: some View {

        NavigationStack(path: $path) {
            screen(for: .waitingChained)
                .navigationDestination(for: Route.self) { route in
                    screen(for: route)
                }
        }
        .environmentObject(doChallengeVM)
        .environmentObject(rec)
        .environmentObject(player)
        .task {
            // Request permission to record when view appears.
            rec.requestPermission { ok in
                // Show an alert if permission is denied.
                micDenied = (ok == false)
            }
        }
        .alert("Cancelar desafio?", isPresented: $showCancelAlert) {
            Button("Manter", role: .cancel) { }
            Button("Cancelar desafio", role: .destructive) {
                
                if currentRoute != .waitingChained {
                    Task { await doChallengeVM.outChallenge() }
                }
                
                dismiss()
            }
        } message: {
            Text("Tem certeza que deseja cancelar? Seu progresso atual será descartado.")
        }
        .alert("Enviar Desafio?", isPresented: $showConfirmAlert) {
            if #available(iOS 26.0, *) {
                Button("Finalizar", role: .confirm) {
                    Task {
                        if let firstURL = doChallengeVM.recordings.first {
                            await doChallengeVM.submitStudentAudio(url: firstURL)
                        }
                        await doChallengeVM.outChallenge()
                        dismiss()
                    }
                }
            } else {
                Button("Finalizar") {
                    Task { await doChallengeVM.outChallenge() }
                    dismiss()
                }
            }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text("Tem certeza que deseja enviar? Não será possível enviar novamente.")
        }
        .alert("Microphone Access Needed", isPresented: $micDenied) {
            Button("OK", role: .cancel) {}
            #if canImport(UIKit)
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            #endif
        } message: {
            Text("Please allow microphone access in Settings to record audio.")
        }
    }
    
    @ViewBuilder
    private func screen(for route: Route) -> some View {
        switch route {
        case .waitingChained:
            WaitingChainedChallengeView { next in
                currentRoute = next
                path.append(next)
            }
            .toolbar { cancelToolbar }
            .navigationBarBackButtonHidden(true)
            .environmentObject(doChallengeVM)
            
        case .initialChained:
            InitialChainedChallengeView { next in
                currentRoute = next
                path.append(next)
            }
            .toolbar { cancelToolbar }
            .navigationBarBackButtonHidden(true)
            .environmentObject(doChallengeVM)
            
        case .receiveChained:
            ReceivedAudioRecordChainedChallengeView { next in
                currentRoute = next
                path.append(next)
            }
            .toolbar { cancelToolbar }
            .navigationBarBackButtonHidden(true)
            .environmentObject(doChallengeVM)

        case .recordChained:
            RecordFromInitialChainedChallengeView { next in
                currentRoute = next
                path.append(next)
            }
            .toolbar {
                cancelToolbar
                confirmToolbar
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private var cancelToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Cancelar", systemImage: "xmark") {
                showCancelAlert = true
            }
            .tint(.black)
        }
    }
    
    private var confirmToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button() {
                showConfirmAlert = true
            } label: {
                Label("Confirmar", systemImage: "checkmark")
            }
            .buttonStyle(.borderedProminent)      // Torna o botão primário
            .tint(Color("BlueChallenge"))         }
    }
}
