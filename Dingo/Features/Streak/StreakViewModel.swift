//
//  StreakViewModel.swift
//  Dingo
//
//  Created by João Victor Perosso Souza on 03/12/25.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
class StreakViewModel: ObservableObject {
    @Published var trainingDates: [Int] = [1, 2, 7]
    @Published private var Streak: Int = 0
    @Published var lastDate: Date?
    
    //@Published var trainingDates: [Int] = []
    
    private let persistenceServices: PersistenceServices
    //static let shared = StreakViewModel()
    static let shared = StreakViewModel(persistenceServices: PersistenceServices.shared)


    //@Published var lastDate = Calendar.current.date(byAdding: .day, value: -4, to: Date())!
    //let today = Calendar.current.date(byAdding: .day, value: +4, to: Date())!
    let calendar = Calendar.current
    var today = Date()
    var wToday: Int { calendar.component(.weekday, from: today) }
    var wLastDate: Int {calendar.component(.weekday, from: lastDate ?? today) }

    @Published var user: UserModel?


    init(persistenceServices: PersistenceServices) {
        self.persistenceServices = persistenceServices
    }
    
    
    func registerTrainingToday() async {
        await updateTrainingDates()
        if(calendar.isDate(today, inSameDayAs: lastDate ?? Calendar.current.date(byAdding: .day, value: -1, to: Date())!)){
            let distance = calendar.dateComponents([.day], from: lastDate ?? today, to: today).day ?? 0
            if(distance < 7){
                Streak += 1
            }else{
                Streak = 0
            }
            //lastDate = today
            trainingDates.append(wToday)
            
            //print("Streak:\(Streak) \n lista\(trainingDates)\n hj: \(today) \(wToday)\n ultimo: \(lastDate) \(wLastDate)")
            
            do {
                try await persistenceServices.updateStreak(streak: Streak.self, lastDate: lastDate.self ?? Date(), trainingDates: trainingDates.self)
                
                
                
                
            } catch {
                print("Failed updating trainingDates: \(error)")
            }
        }
        
    }
    
    //This makes the list of dates clear if the week change
    func updateTrainingDates() async{
        let distance = calendar.dateComponents([.day], from: lastDate ?? today, to: today).day ?? 0
        if(wLastDate > wToday || distance >= 7){
            trainingDates.removeAll()
            do {
                try await persistenceServices.updateStreak(streak: Streak.self, lastDate: lastDate.self ?? Date(), trainingDates: trainingDates.self)
                user?.trainingDates = trainingDates
                
            } catch {
                print("Failed updating trainingDates: \(error)")
            }
            
        }
        
        
    }
    
    
    func getStreak() -> Int{
        return Streak
    }
    
   
    func loadStreak() async {
        do {
            let fetchedStreak = try await persistenceServices.fetchUserStreak()
            
            print("Streak coletada com sucesso: \(fetchedStreak)")
         
            
            Streak = fetchedStreak.streak
            trainingDates = fetchedStreak.trainingDates ?? []
            lastDate = fetchedStreak.lastDate
            //print("\n ***********************streakViewModel: \(fetchedStreak.streak) \n trainingDates: \(fetchedStreak.trainingDates) \n lastDate: \(fetchedStreak.lastDate ?? Date())")

        } catch {
            print("Failed to load user: \(error)")
        }
    }

    
//    func daysOfWeekTrained() -> Set<Int> {
//        let calendar = Calendar.current
//        let weekdays = trainingDates.map { calendar.component(.weekday, from: $0) }
//        return Set(weekdays)
//    }
}
