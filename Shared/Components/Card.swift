//
//  Card.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 14/11/25.
//

import SwiftUI

struct Card: View {
    let name: String
    let quantity: Int

    var body: some View {
        HStack {
//            if let image = grupo.image {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 60, height: 60)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
//            }
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                
                Text("\(quantity)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)

    }
}

//#Preview {
//    Card()
//}
