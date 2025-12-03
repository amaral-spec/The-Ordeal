//
//  SearchViewModel.swift
//  Dingo
//
//  Created by Gabriel Amaral on 03/12/25.
//

import Foundation
import CloudKit

final class SearchViewModel: ObservableObject {
    @Published var generalSearch: ([UserModel], [GroupModel], [ChallengeModel], [TaskModel]) = ([], [], [], [])
    @Published var isSearchEmpty: Bool = true
    let persistence: PersistenceServices
    
    init(persistence: PersistenceServices) {
        self.persistence = persistence
    }
    
    func carregarSearch(prompt: String) async {
        guard !prompt.isEmpty else {
            await MainActor.run {
                generalSearch = ([], [], [], [])
                isSearchEmpty = true
            }
            return
        }
        
        do {
            let results = try await persistence.generalSearch(
                prompt: prompt,
            )
            
            await MainActor.run {
                generalSearch = results
                isSearchEmpty = results.0.isEmpty &&
                results.1.isEmpty &&
                results.2.isEmpty &&
                results.3.isEmpty
            }
            print("Users:", results.0.count)
            print("Groups:", results.1.count)
            print("Challenges:", results.2.count)
            print("Tasks:", results.3.count)
            
        } catch {
            print("Erro ao carregar search: \(error.localizedDescription)")
        }
    }
}
