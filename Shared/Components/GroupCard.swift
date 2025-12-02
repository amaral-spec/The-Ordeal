//
//  GroupCard.swift
//  Dingo
//
//  Created by Jordana Lourenço Santos on 02/12/25.
//

import SwiftUI

struct GroupCard: View {
    let grupo: GroupModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
              Text(grupo.name)
                .font(.headline)
              Text("Código: \(grupo.groupCode)")
                .font(.subheadline)
            }
            Spacer()
            VStack(alignment: .trailing) {
              Spacer()
              Text("\(grupo.members.count) alunos")
                .font(.subheadline.bold().italic())
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}


