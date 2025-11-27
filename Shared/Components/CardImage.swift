//
//  CardImage.swift
//  OsVigaristas
//
//  Created by Jordana Lourenço Santos on 27/11/25.
//

import SwiftUI

struct TaskImage: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("GreenCard"))
                .frame(width: 45, height: 45)
            
            Image(systemName: "checklist.checked")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.white)
        }
    }
}

struct GrayTaskImage: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.gray)
                .frame(width: 45, height: 45)
            
            Image(systemName: "checklist.checked")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.white)
        }
    }
}

struct ChallengeImage: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("BlueCard"))
                .frame(width: 45, height: 45)
            
            Image(systemName: "flag.pattern.checkered.2.crossed")
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
                .foregroundColor(.white)
        }
    }
}

struct GrayChallengeImage: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.gray)
                .frame(width: 45, height: 45)
            
            Image(systemName: "flag.pattern.checkered.2.crossed")
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
                .foregroundColor(.white)
        }
    }
}
