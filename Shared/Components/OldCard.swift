//
//  CardView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 12/11/25.
//

import SwiftUI

struct OldCard: View {
    let index: Int
    
    var body: some View {
        ZStack {
            Image("partitura")
                .resizable()
                .frame(width: 370, height: 190)
                .cornerRadius(30)
                .zIndex(0)
            
            HStack {
                VStack {
                    Text("Desafio")
                        .font(.title3.bold())
                        .frame(width: 160, alignment: .bottomLeading)
                    Text("Grupo Johnny's")
                        .font(.body)
                        .frame(width: 160, alignment: .leading)
                }
                .frame(height: 150, alignment: .bottomLeading)
                Spacer()
                Text("Disponível até 22/10")
                    .font(
                        .headline
                            .bold()
                            .italic()
                    )
                    .frame(width: 100, height: 150, alignment: .bottomTrailing)
            }
            .frame(width: 320, height: 150)
            .multilineTextAlignment(.trailing)
            .foregroundColor(.white)
            .zIndex(3)
            .frame(width: 370, height: 189)
            .background(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: .black.opacity(0.85), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.28, green: 0.28, blue: 0.28).opacity(0.1), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0.75),
                    endPoint: UnitPoint(x: 0.5, y: 0)
                )
            )
            .cornerRadius(30)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 370, height: 90, alignment: .bottom)
                .background(
                    Image("partitura")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 370, height: 95, alignment: .bottom)
                        .clipped()
                )
                .frame(width: 370, height: 190, alignment: .bottom)
                .zIndex(2)
                .blur(radius: 25)
        }
    }
}

//#Preview {
//    CardView()
//}
