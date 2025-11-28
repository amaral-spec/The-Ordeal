//
//  ListCard.swift
//  OsVigaristas
//
//  Created by Jordana Lourenço Santos on 27/11/25.
//

import SwiftUI

struct ListCard: View  {
    let title: String
    let subtitle: String
    let image: any View
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.12), radius: 5, y: 3)
            
            HStack(spacing: 16) {
                AnyView(image)
                
                Text(title)
                    .font(.title3.bold())
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(subtitle)
                    .font(.caption.italic())
                    .foregroundColor(.black)
            }
            .padding()
        }
        
        
    }
}
