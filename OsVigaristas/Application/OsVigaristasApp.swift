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

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(authService)
                .environmentObject(persistenceServices)
                .preferredColorScheme(.light)
        }
    }
}
