//
//  OsVigaristasApp.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 27/10/25.
//

import SwiftUI
import SwiftData

@main
struct OsVigaristasApp: App {
    @StateObject private var authService = AuthService.shared
    @StateObject private var persistenceServices = PersistenceServices.shared
    @StateObject private var detector = InstrumentDetectionViewModel.shared
    @StateObject private var streakVM = StreakViewModel.shared



    var body: some Scene {
        WindowGroup {
            AppRootView()
                //RecebeuAudioGravarDesafioEncadeiaView()
                .environmentObject(authService) // Compartilha o estado global de login
                .environmentObject(persistenceServices) // Compartilha funcoes do CloudKit
                .preferredColorScheme(.light)
                .environmentObject(detector)//Compartilha funcoes do coreMl
                .environmentObject(streakVM)

        }
    }
}
