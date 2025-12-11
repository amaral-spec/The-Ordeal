//
//  TrainingCardView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 24/11/25.
//

import SwiftUI

import SwiftUI

struct TrainingCardView: View {
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color("RedCard"))
            
            VStack {
                HStack {
                    Text("Treino")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Spacer()
                }
                Spacer()
                
                Image("custom.music.pages.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
            
        }
        .frame(height: 200)
    }
}

#Preview {
    TrainingCardView()
}
