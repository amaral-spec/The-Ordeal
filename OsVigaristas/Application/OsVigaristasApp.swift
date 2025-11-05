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
    
    var sharedModelContainer: ModelContainer = {

        let schema = Schema([Usuarios.self,
                             Grupos.self,
                             Tarefas.self,
                             Desafio.self])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .private("iCloud.eumesmo.OsVigaristas")
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(authService) // Compartilha o estado global de login
                // TODO: rever isso aq mno parece ser iCloud
                .modelContainer(sharedModelContainer)
                .preferredColorScheme(.light)
            // ContentView(authVM: AuthViewModel(modelContext: sharedModelContainer.mainContext))
        }
    }
}
