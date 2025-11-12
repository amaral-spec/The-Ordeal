//
//  BuscarView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 10/11/25.
//

import SwiftUI

struct BuscarView: View {
    
    var body: some View {
        NavigationStack {
            List {
                Section("Alunos") {
                    Text("Nome Aluno")
                    Text("Nome Aluno")
                    Text("Nome Aluno")
                }
                
                Section("Grupos") {
                    Text("Nome Group")
                    Text("Nome Group")
                    Text("Nome Group")
                    Text("Nome Group")
                    Text("Nome Group")
                }
            }
        }
    }
}

#Preview {
    BuscarView()
}
