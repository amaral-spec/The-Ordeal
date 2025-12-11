//
//  MakeChallengeCoordinator.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 19/11/25.
//

import SwiftUI

struct DoChallengeCoordinatorView: View {
    enum Route: Hashable {
        case waiting
        case initial
        case receive
        case recordInitial
        case recordReceived
    }
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var persistenceServices: PersistenceServices
    
    @State private var path: [Route] = []
    
    @State private var showCancelAlert: Bool = false
    @State private var showConfirmAlert: Bool = false
    
    @StateObject private var doChallengeVM: DoChallengeViewModel
    @StateObject private var rec = MiniRecorder()
    @StateObject private var player = MiniPlayer()
    
    @State private var currentRoute: Route
    @State private var micDenied = false
    
    // 1. Correção na declaração (removido o valor default)
    @Binding private var alreadyDone: Bool

    // 2. Correção no Init
    init(challengeM: ChallengeModel, alreadyDone: Binding<Bool>) {
        // Inicializa o StateObject
        _doChallengeVM = StateObject(wrappedValue: DoChallengeViewModel(persistenceServices: PersistenceServices.shared, challengeM: challengeM))
        
        // Inicializa o Binding usando o underscore (_)
        _alreadyDone = alreadyDone
        
        // Inicializa o State simples
        _currentRoute = State(initialValue: .waiting)
    }

    var body: some View {

        NavigationStack(path: $path) {
            screen(for: self.currentRoute)
                .navigationDestination(for: Route.self) { route in
                    screen(for: route)
                }
        }
        .environmentObject(doChallengeVM)
        .environmentObject(rec)
        .environmentObject(player)
        .task {
            rec.requestPermission { ok in
                micDenied = (ok == false)
            }
        }
        .alert("Cancelar desafio?", isPresented: $showCancelAlert) {
            Button("Manter", role: .cancel) { }
            Button("Descartar desafio", role: .destructive) {
                if currentRoute != .waiting {
                    Task { await doChallengeVM.outChallenge() }
                }
                dismiss()
            }
        } message: {
            Text("Tem certeza que deseja cancelar? Seu progresso atual será descartado.")
        }
        .alert("Enviar Desafio?", isPresented: $showConfirmAlert) {
            // Nota: iOS 26.0 ainda não existe, assumindo que seja uma verificação futura ou placeholder
            if #available(iOS 26.0, *) {
                Button("Finalizar", role: .confirm) {
                    finalizeChallenge()
                }
            } else {
                Button("Finalizar") {
                    finalizeChallenge()
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
    
    // MARK: - Helper Methods
    
    private func finalizeChallenge() {
        Task {
            if let firstURL = doChallengeVM.recordings.first {
                await doChallengeVM.submitStudentAudio(url: firstURL)
            }
            await doChallengeVM.outChallenge()
            
            // 3. Atualiza a variável binding para avisar a tela anterior
            alreadyDone = true
            
            dismiss()
        }
    }
    
    @ViewBuilder
    private func screen(for route: Route) -> some View {
        switch route {
        case .waiting:
            WaitingView { next in
                currentRoute = next
                path.append(next)
            }
            .toolbar { cancelWaitingToolbar }
            .navigationBarBackButtonHidden(true)
            .environmentObject(doChallengeVM)
            
        case .initial:
            InitialView { next in
                currentRoute = next
                path.append(next)
            }
            .toolbar { cancelToolbar }
            .navigationBarBackButtonHidden(true)
            .environmentObject(doChallengeVM)
            
        case .receive:
            ReceivedAudioView { next in
                currentRoute = next
                path.append(next)
            }
            .toolbar { cancelToolbar }
            .navigationBarBackButtonHidden(true)
            .environmentObject(doChallengeVM)
            
        case .recordInitial:
            RecordFromInitialView { next in
                currentRoute = next
                path.append(next)
            }
            .toolbar {
                cancelToolbar
                confirmToolbar
            }
            .navigationBarBackButtonHidden(true)
            
        case .recordReceived:
            RecordFromReceivedView { next in
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
    
    private var cancelWaitingToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Cancelar", systemImage: "xmark") {
                dismiss()
            }
            .tint(.black)
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
            .buttonStyle(.borderedProminent)
            .tint(Color("BlueCard"))
        }
    }
}
