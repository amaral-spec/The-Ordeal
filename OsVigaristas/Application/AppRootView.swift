//
//  AppRootView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 04/11/25.
//


import SwiftUI

struct AppRootView: View {
    @EnvironmentObject var authService: AuthService
    @Environment(\.modelContext) var modelContext

    init() {
//        print("OIIIIs")
    }
    
    var body: some View {
        Group {
            if !authService.isLoggedIn {
                AuthCoordinatorView()   // fluxo de login/cadastro
            } else if (authService.currentUser!.isTeacher) {
                ProfessorMainCoordinatorView()
            } else {
                AlunoMainCoordinatorView()
            }
        }
        .animation(.easeInOut, value: authService.isLoggedIn)
    }
}
