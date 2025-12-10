//
//  MakeChallengeCoordinator.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 19/11/25.
//

import SwiftUI

struct DoTaskCoordinatorView: View {
    enum Route: Hashable {
        case initialTask
        case recordTask
    }
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var persistenceServices: PersistenceServices
    
    @State private var path: [Route] = [.initialTask]
    
    @State private var showCancelAlert: Bool = false
    @State private var showConfirmAlert: Bool = false
    
    @ObservedObject var doTaskVM: DoTaskViewModel
    @StateObject private var rec = MiniRecorder()
    @StateObject private var player = MiniPlayer()
    
    @State private var currentRoute: Route = .initialTask
    @State private var micDenied = false


    init(doTaskVM: DoTaskViewModel) {
        self.doTaskVM = doTaskVM
    }

    var body: some View {

        NavigationStack(path: $path) {
            screen(for: .initialTask)
                .navigationDestination(for: Route.self) { route in
                    screen(for: route)
                }
        }
        .tint(Color("GreenCard"))
        .environmentObject(doTaskVM)
        .environmentObject(rec)
        .environmentObject(player)
        .task {
            // Request permission to record when view appears.
            rec.requestPermission { ok in
                // Show an alert if permission is denied.
                micDenied = (ok == false)
            }
        }
        .alert("Descartar tarefa?", isPresented: $showCancelAlert) {
            Button("Manter", role: .cancel) { }
            Button("Descartar tarefa", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Tem certeza que deseja cancelar? Seu progresso atual será descartado.")
        }
        .alert("Enviar Tarefa?", isPresented: $showConfirmAlert) {
            if #available(iOS 26.0, *) {
                Button("Finalizar", role: .confirm) {
                    Task {
                        if let firstURL = doTaskVM.recordings.first {
                            await doTaskVM.submitStudentAudio(url: firstURL)
                        }
                        dismiss()
                    }
                }
            } else {
                Button("Finalizar") {
                    Task {
                        if let firstURL = doTaskVM.recordings.first {
                            await doTaskVM.submitStudentAudio(url: firstURL)
                        }
                        dismiss()
                    }
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
            
        case .initialTask:
            InitialTaskView { next in
                currentRoute = next
                path.append(next)
            }
            .toolbar { cancelToolbar }
            .navigationBarBackButtonHidden(true)
            .environmentObject(doTaskVM)

        case .recordTask:
            RecordFromInitialTaskView { next in
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
            .tint(Color("GreenCard"))
        }
    }
}
