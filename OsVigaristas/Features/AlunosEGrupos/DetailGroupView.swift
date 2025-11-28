//
//  DetalheGrupoView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 11/11/25.
//

import SwiftUI

struct DetailGroupView: View {
    let grupo: GroupModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
//                Image(uiImage: (grupo.image ?? UIImage(systemName: "waveform"))
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 140, height: 140)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                    .shadow(radius: 5)
                
                Text(grupo.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("\(grupo.members.count) participantes")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Button {
                    //func para copiar o codigo?
                } label: {
                    Text("Código do grupo: \(grupo.groupCode)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 350, maxHeight: 52)
                        .background(Color("AccentColor"))
                        .cornerRadius(50)
                }
                .frame(maxWidth: .infinity, minHeight: 70)
                .padding()
            }
            .padding()
            .navigationTitle("Detalhes do Grupo")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(Color(.secondarySystemBackground))
    }
}

#Preview {
    DetailGroupView(grupo: GroupModel(name: "Exemplo de Grupo"))
}
