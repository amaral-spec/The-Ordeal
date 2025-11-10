//
//  ProfessorMainCoordinator.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 04/11/25.
//

import SwiftUI

enum alunoTabs {
    case inicio, treino, perfil, buscar
}

struct AlunoMainCoordinatorView: View {
    @StateObject private var authVM: AuthViewModel
    @State private var selectedTab: alunoTabs = .inicio
    @State private var searchText: String = ""
    
    init() {
        print("Aluno")
        _authVM = StateObject(wrappedValue: AuthViewModel(authService: AuthService.shared))
    }

    var body: some View {
        
        TabView(selection: $selectedTab) {
            Tab("Início", systemImage: "music.note.house.fill", value: .inicio) {
                VStack {
                    Text("Tela Principal (Logado)")
                }
            }
            Tab("Treino", systemImage: "music.pages", value: .treino) {
                Text("Treino View")
            }
            Tab("Perfil", systemImage: "person.fill", value: .perfil) {
                PerfilCoordinatorView(isProfessor: false)
                    .environmentObject(authVM)
            }
            Tab("Buscar", systemImage: "magnifyingglass", value: .buscar, role: .search) {
                Text("Buscar View")
            }
        }
        .tint(Color(red: 0.65, green: 0.13, blue: 0.29))
    }
}
