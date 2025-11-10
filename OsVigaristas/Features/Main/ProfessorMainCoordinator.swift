//
//  ProfessorMainCoordinator.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 04/11/25.
//

import SwiftUI

struct ProfessorMainCoordinatorView: View {
    @StateObject private var authVM: AuthViewModel
    @State private var searchText: String = ""
    
    init() {
        print("professor")
        _authVM = StateObject(wrappedValue: AuthViewModel(authService: AuthService.shared))
    }

    var body: some View {
        
        TabView() {
            Tab("Início", systemImage: "house") {
                HomeView()
            }
            Tab("Alunos", systemImage: "person.3") {
                Text("Alunos View")
            }
            Tab("Perfil", systemImage: "person.crop.circle") {
                PerfilCoordinatorView(isProfessor: true)
                    .environmentObject(authVM)
            }
            Tab("Buscar", systemImage: "magnifyingglass", role: .search) {
                Text("Buscar View")
            }
        }
        .tint(Color(red: 0.65, green: 0.13, blue: 0.29))
        .searchable(text: $searchText)
    }
}
