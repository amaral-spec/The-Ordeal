//
//  MeusGrupos.swift
//  Dingo
//
//  Created by Jordana Lourenço Santos on 02/12/25.
//

import SwiftUI

struct MeusGrupos: View {
    @EnvironmentObject var perfilVM: PerfilViewModel
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(perfilVM.fetchedAllGroups){ grupo in
                    GroupCard(grupo: grupo)
                        .padding()
                }
            }
        }
        .navigationTitle("Meus grupos")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await perfilVM.fetchAllGroups()
        }
    }
}
