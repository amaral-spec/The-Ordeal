//
//  DesafiosViewModel.swift
//  OsVigaristas
//
//  Created by João Victor Perosso Souza on 14/11/25.
//

import SwiftUI
import Foundation

struct IconImageView: View{
    var nomeIcone: String = "waveform"
    
    var body: some View {
        ZStack{ //Imagem no meio estranha
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(Color("BlueChallengeBackground"))
            
            Image(systemName: nomeIcone)
                .foregroundColor(Color("BlueChallenge"))
                .font(.system(size: 25))
        }
    
        
    }
}

struct ImageMessageView: View {
    var title: String
    var subtitle: String
    var body: some View{
        
        VStack{
            Text(title)
                .font(.title2.bold())
            Text(subtitle)
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
    
}

struct RecordingButtonView: View{
    var isRecording: Bool
    
    var body: some View{
        
            Image(systemName: isRecording ? "stop.circle.fill" : "record.circle.fill")
                .resizable()
                .foregroundColor(Color("BlueChallenge"))
                .padding(.trailing, 1)
                .frame(width: 64, height: 64)
//                .padding()
    
    }
}

struct AudioRepresentationView: View{
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .frame(width:.infinity, height: 70)
                .padding()
                .foregroundColor(Color.gray.opacity(0.4))
                //.shadow(radius: 10)//Tirar
            
            HStack{
                Button{
                    
                }label: {
                   
                    Image(systemName: "play.circle")
                        .font(.system(size: 36))
                        .foregroundStyle(Color(.black))
                    
                }
                .padding()
                
                Spacer()
                
            }.frame(width:.infinity, height: 80)
            .padding()
        }
    }
}

struct TopPageInstructionView: View{
    var instruction: String
    var body: some View{
        Text(instruction)
            .padding()
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.title3.bold())
    }
}
