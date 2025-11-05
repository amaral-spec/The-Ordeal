//
//  ProfessorMainCoordinator.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 04/11/25.
//

import SwiftUI

struct ProfessorMainCoordinatorView: View {

    init() {
        print("professor")
    }
    

    var body: some View {
        TabView {
            DesafiosCoordinatorView(isProfessor: true)
                .tabItem { Label("Desafios", systemImage: "music.note.list") }

//            AlunosCoordinatorView()
            EmptyView()
                .tabItem { Label("Alunos", systemImage: "person.3") }

            PerfilCoordinatorView(isProfessor: true)
                .tabItem { Label("Perfil", systemImage: "person.crop.circle") }
        }
    }
}
