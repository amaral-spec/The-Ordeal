//
//  AlunosViewCard.swift
//  OsVigaristas
//
//  Created by Júlio Zampietro on 27/11/25.
//

import SwiftUI
import CloudKit


struct AlunosViewCard: View {
    let aluno: UserModel
    
    var body: some View {
        VStack {
            Group {
                if let uiImage = aluno.profileImage {
                    Image(uiImage: uiImage)
                        .resizable()
                }
//                } else {
//                    Image("partitura")
//                        .resizable()
//                }
            }
            .scaledToFill()
            .frame(width: 70, height: 70)
            .clipShape(Circle())
            
            Text(aluno.name)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}


