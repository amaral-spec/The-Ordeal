//
//  StreakViewModel.swift
//  Dingo
//
//  Created by João Victor Perosso Souza on 03/12/25.
//

import Foundation
import UIKit
import SwiftUI

class StreakViewModel: ObservableObject {
    @Published var trainingDates: [Int] = [1, 2, 7]
    //@Published var trainingDates: [Int] = []
    static let shared = StreakViewModel()

    @Published private var Streak: Int = 0
    @Published var lastDate: Date?
    //@Published var lastDate = Calendar.current.date(byAdding: .day, value: -4, to: Date())!
    //let today = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
    let calendar = Calendar.current
    var today = Date()
    var wToday: Int { calendar.component(.weekday, from: today) }
    var wLastDate: Int {calendar.component(.weekday, from: lastDate ?? today) }

    func registerTrainingToday() {
        updateTrainingDates()
        let distance = calendar.dateComponents([.day], from: lastDate ?? today, to: today).day ?? 0
        if(distance < 7){
            Streak += 1
        }else{
            Streak = 0
        }
        //lastDate = today
        trainingDates.append(wToday)
        
        print("Streak:\(Streak) \n lista\(trainingDates)\n hj: \(today) \(wToday)\n ultimo: \(lastDate) \(wLastDate)")
        
    }
    
    //This makes the list of dates clear if the week change
    func updateTrainingDates(){
        let distance = calendar.dateComponents([.day], from: lastDate ?? today, to: today).day ?? 0
        if(wLastDate >= wToday || distance >= 7){
            trainingDates.removeAll()
        }
    }
    func getStreak() -> Int{
        return Streak
    }
    
//    func daysOfWeekTrained() -> Set<Int> {
//        let calendar = Calendar.current
//        let weekdays = trainingDates.map { calendar.component(.weekday, from: $0) }
//        return Set(weekdays)
//    }
}
