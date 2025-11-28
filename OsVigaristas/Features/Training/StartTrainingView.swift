//
//  StartTrainingView.swift
//  CoreMLtest
//
//  Created by João Victor Perosso Souza on 26/11/25.
//

import SwiftUI

struct StartTrainingView: View {
    @State private var showTimer = false
    let onNavigate: (TrainingCoordinatorView.Route) -> Void
    var body: some View {
        VStack{
            Spacer()
            CircleWithIcon()
            Text("Treine agora")
                .font(.system(size: 22))
                .fontWeight(.bold)
            
            Text("Mantenha sua streak!")
                .font(.system(size: 20))
                .foregroundColor(.gray)
            Spacer()
            
            Button{
                onNavigate(.stopwatch)
                
            } label:{
                ZStack{
                    RoundedRectangle(cornerRadius: 100)
                        .frame(width: .infinity, height: 50)
                        .padding()
                        .padding(.horizontal)
                    //.cornerSize(10)
                        .foregroundStyle(Color("AccentColor"))
                    
                    Text("Iniciar")
                        .foregroundStyle(Color.white)
                        .font(Font.system(size: 17))
                }
            }
        }
        
}

struct CircleWithIcon: View {
        var body: some View {
            ZStack{
                Circle()
                    .frame(width: 50)
                    .foregroundColor(Color("AccentColor"))//Change
                    .opacity(0.15)
                    .padding()
                Image(systemName: "music.pages.fill")
                
                    .frame(width: 22)
                    .font(.system(size: 22))
                    .foregroundColor(Color("AccentColor"))//Change
                }
            }
        }
    }
#Preview {
    StartTrainingView(onNavigate: { _ in })
}
