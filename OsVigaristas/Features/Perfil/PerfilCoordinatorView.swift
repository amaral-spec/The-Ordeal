//
//  PerfilCoordinatorView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 04/11/25.
//

import SwiftUI

struct PerfilCoordinatorView: View {
    let isProfessor: Bool

    var body: some View {
        if isProfessor {
//            ProfessorPerfilView(viewModel: PerfilViewModel(userType: .professor))
            Text("Perfil Professor")
        } else {
            Text("Perfil Aluno")
//            AlunoPerfilView(viewModel: PerfilViewModel(userType: .aluno))
        }
    }
}
