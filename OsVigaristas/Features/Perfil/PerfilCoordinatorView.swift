//
//  PerfilCoordinatorView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 04/11/25.
//

import SwiftUI

struct PerfilCoordinatorView: View {
    @EnvironmentObject var authVM: AuthViewModel
    let isProfessor: Bool

    var body: some View {
        if isProfessor {
//            ProfessorPerfilView(viewModel: PerfilViewModel(userType: .professor))
            Text("Perfil Professor")
            Button("Logout") {
                authVM.logout()
            }
        } else {
//            Text("Perfil Aluno")
//            Button("Logout") {
//                authVM.logout()
//            }
            PerfilView()
//            AlunoPerfilView(viewModel: PerfilViewModel(userType: .aluno))
        }
    }
}
