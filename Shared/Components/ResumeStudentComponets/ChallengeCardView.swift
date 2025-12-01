//
//  ChallengeCardView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 24/11/25.
//

import SwiftUI

struct ChallengeCardView: View {
    @ObservedObject var resumoVM: ResumeViewModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(resumoVM.challenges.isEmpty ? .gray : Color("BlueCard"))
            
            if resumoVM.challenges.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.6)
                    .tint(.white)
            } else {
                VStack {
                    HStack {
                        Text("Desafio")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        
                        Spacer()
                        if !resumoVM.isTeacher {
                            Text("Faltam 2 dias")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    
                    Spacer()
                    
                    Image("flag.pattern.checkered.2.crossed.circle.fill")
                        .font(.system(size: 140))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .frame(height: 220)
        .task {
            await resumoVM.carregarDesafios()
        }
    }
}

