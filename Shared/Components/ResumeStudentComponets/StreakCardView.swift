//
//  StreakCardView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 24/11/25.
//

import SwiftUI
import UIKit

struct StreakCardView: View {
    @EnvironmentObject var streakVM: StreakViewModel
    let calendar = Calendar.current
    var today: Int { calendar.component(.weekday, from: Date()) }
    
    var body: some View {
        HStack(spacing: 16) {
            //Fogo grande
            VStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundColor(Color("RedCard"))
                    .font(.system(size: 32))

                Text("\(streakVM.getStreak())")
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
                        }else if(today > stringToIntDay(day: day)){
                            VStack(spacing: 4) {
                                Text(day)
                                    .font(.caption2)
                                
                                Image(systemName: "xmark.circle.fill")
                                //Image(systemName: "circle.dotted")
                                    .foregroundColor(Color(.gray))
                            }
                        }else{
                            VStack(spacing: 4) {
                                Text(day)
                                    .font(.caption2)
                                
                                //Image(systemName: "xmark.circle.fill")
                                Image(systemName: "circle.dotted")
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
            streakVM.updateTrainingDates()
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
    
    d = stringToIntDay(day: day)
    
    return doneDays.contains(d)
}

func stringToIntDay(day: String) -> Int {
    switch day{
    case "Dom":
        return 1
        break
    case "Seg":
        return 2
        break
    case "Ter":
        return 3
        break
    case "Qua":
        return 4
        break
    case "Qui":
        return 5
        break
    case "Sex":
        return 6
        break
    case "Sab":
        return 7
    default:
        return 0
    }
    
}

#Preview {
    StreakCardView()
}
