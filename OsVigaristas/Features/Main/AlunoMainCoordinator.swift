//
//  AlunoMainCoordinator.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 04/11/25.
//

import SwiftUI

struct AlunoMainCoordinatorView: View {
    
    init() {
        print("aluno")
    }
    
    var body: some View {
        TabView {
            DesafiosCoordinatorView(isProfessor: false)
                .tabItem { Label("Desafios", systemImage: "music.quarternote.3") }

//            TreinoCoordinatorView()
//            EmptyView()
//                .tabItem { Label("Treino", systemImage: "metronome") }

            PerfilCoordinatorView(isProfessor: false)
                .tabItem { Label("Perfil", systemImage: "person.circle") }
        }
    }
}
