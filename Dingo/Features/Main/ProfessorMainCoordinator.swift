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
    @StateObject private var perfilVM: PerfilViewModel
    @State private var selectedTab: professorTabs = .inicio
    @State private var searchText: String = ""
    @StateObject private var searchVM = SearchViewModel(persistence: PersistenceServices())

    
    init() {
        print("professor")
        _authVM = StateObject(wrappedValue: AuthViewModel(authService: AuthService.shared))
        _perfilVM = StateObject(wrappedValue: PerfilViewModel(persistenceServices: PersistenceServices()))
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Início", systemImage: "music.note.house.fill", value: .inicio) {
                ResumeCoordinatorView(isTeacher: true)
            }
            Tab("Alunos", systemImage: "person.3", value: .alunos) {
                AlunosCoordinatorView()
            }
            Tab("Perfil", systemImage: "person.fill", value: .perfil) {
                PerfilCoordinatorView(isTeacher: true)
                    .environmentObject(perfilVM)
            }
            Tab("Buscar", systemImage: "magnifyingglass", value: .buscar, role: .search) {
                NavigationStack {
                    BuscarView()
                        .environmentObject(searchVM)
                        .navigationTitle("Buscar")
                        .toolbarTitleDisplayMode(.inlineLarge)
                }
                .searchable(text: $searchText)
                .onChange(of: searchText) { newValue in
                    Task { await searchVM.carregarSearch(prompt: newValue) }
                }
            }
        }
        .tint(Color.accentColor)
        //        .searchable(text: $searchText)
    }
}

#Preview {
    ProfessorMainCoordinatorView()
}
