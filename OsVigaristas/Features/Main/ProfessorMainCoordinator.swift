//
//  ProfessorMainCoordinator.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 04/11/25.
//

import SwiftUI

enum professorTabs {
    case inicio, alunos, perfil, buscar
}

struct ProfessorMainCoordinatorView: View {
    @StateObject private var authVM: AuthViewModel
    @State private var selectedTab: professorTabs = .inicio
    @State private var searchText: String = ""
    
    init() {
        print("professor")
        _authVM = StateObject(wrappedValue: AuthViewModel(authService: AuthService.shared))
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Início", systemImage: "music.note.house.fill", value: .inicio) {
                HomeView()
            }
            Tab("Alunos", systemImage: "person.3", value: .alunos) {
                AlunosView()
            }
            Tab("Perfil", systemImage: "person.fill", value: .perfil) {
                PerfilCoordinatorView(isProfessor: true)
                    .environmentObject(authVM)
            }
            Tab("Buscar", systemImage: "magnifyingglass", value: .buscar, role: .search) {
                NavigationStack {
                        BuscarView()
                            .navigationTitle("Buscar")
                            .toolbarTitleDisplayMode(.inlineLarge)
                    }
                    .searchable(text: $searchText)
                }
        }
        .tint(Color(red: 0.65, green: 0.13, blue: 0.29))
//        .searchable(text: $searchText)
    }
}
