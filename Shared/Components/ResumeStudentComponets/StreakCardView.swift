//
//  StreakCardView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 24/11/25.
//

import SwiftUI

struct StreakCardView: View {
    @EnvironmentObject var streakVM: StreakViewModel
    var body: some View {
        HStack(spacing: 16) {
            //Fogo grande
            VStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundColor(Color("RedCard"))
                    .font(.system(size: 32))

                Text("\(streakVM.getStreak()))
                    .font(.title3.bold())
            }
            .frame(width: 45, alignment: .center)

            //Foguinhos e dias
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 20) {
                    ForEach(["Dom","Seg","Ter","Qua","Qui","Sex","Sab"], id: \.self) { day in
                        
                        
                        if(daysDone(day: day.self, doneDays: streakVM.trainingDates)){
                            VStack(spacing: 4) {
                                Text(day)
                                    .font(.caption2)

                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color("RedCard"))
                            }
                        }else{
                            VStack(spacing: 4) {
                                Text(day)
                                    .font(.caption2)
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(.gray))
                            }
                        }
                    }
                }

                //Aviso
                Text("Atenção! Uma semana sem treinar zera sua streak!")
                    .font(.caption2.italic())
                    .foregroundColor(.gray)
            }
        }
        //.padding()
        .onAppear(){
            //streakVM.updateTrainingDates()
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
        .padding(.horizontal)
        
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                .frame(maxWidth: .infinity)
        )
        
        
        
    }
        
    
}


func daysDone(day: String, doneDays: [Int]) -> Bool {
    
    var d: Int = -1
    
    switch day{
    case "Dom":
        d = 1
        break
    case "Seg":
        d = 2
        break
    case "Ter":
        d = 3
        break
    case "Qua":
        d = 4
        break
    case "Qui":
        d = 5
        break
    case "Sex":
        d = 6
        break
    case "Sab":
        d = 7
    default:
        d = 0
    }
    
    return doneDays.contains(d)
}

#Preview {
    StreakCardView()
}
