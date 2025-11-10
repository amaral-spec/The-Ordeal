//
//  ProfessorMainCoordinator.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 04/11/25.
//

import SwiftUI

struct AlunoMainCoordinatorView: View {
    @StateObject private var authVM: AuthViewModel
    @State private var searchText: String = ""
    
    init() {
        print("Aluno")
        _authVM = StateObject(wrappedValue: AuthViewModel(authService: AuthService.shared))
    }

    var body: some View {
        
        TabView() {
            Tab("Início", systemImage: "music.note.house.fill") {
                VStack {
                    Text("Tela Principal (Logado)")
                }
            }
            Tab("Treino", systemImage: "music.pages") {
                Text("Treino View")
            }
            Tab("Perfil", systemImage: "person.fill") {
                PerfilCoordinatorView(isProfessor: false)
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
