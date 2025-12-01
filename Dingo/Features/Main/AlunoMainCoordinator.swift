//
//  ProfessorMainCoordinator.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 04/11/25.
//

import SwiftUI

enum studentTabs {
    case resume, training, perfil, search
}

struct StudentMainCoordinatorView: View {
    @StateObject private var authVM: AuthViewModel
    @State private var selectedTab: studentTabs = .resume
    @State private var searchText: String = ""
    
    init() {
        _authVM = StateObject(wrappedValue: AuthViewModel(authService: AuthService.shared))
    }

    var body: some View {
        
        TabView(selection: $selectedTab) {
            Tab("Início", systemImage: "music.note.house.fill", value: .resume) {
                ResumeCoordinatorView(isTeacher: false)
                    .environment(\.selectedStudentTab, $selectedTab)
            }
            Tab("Perfil", systemImage: "person.fill", value: .perfil) {
                PerfilCoordinatorView(isProfessor: false)
                    .environmentObject(authVM)
            }
            Tab("Buscar", systemImage: "magnifyingglass", value: .search, role: .search) {
                NavigationStack {
                    BuscarView()
                        .navigationTitle("Buscar")
                        .toolbarTitleDisplayMode(.inlineLarge)
                }
                .searchable(text: $searchText)
            }
        }
        .tint(Color.accentColor)
//        .searchable(text: $searchText)
    }
}

#Preview {
    StudentMainCoordinatorView()
}
