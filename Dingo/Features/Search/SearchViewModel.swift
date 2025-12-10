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
    @Published var isLoading: Bool = false
    @Published var resultsLoaded: Bool = false

    let persistence: PersistenceServices
    
    init(persistence: PersistenceServices) {
        self.persistence = persistence
    }
    
    @MainActor
    func carregarSearch(prompt: String) async {
        isLoading = true
        resultsLoaded = false
        
        let minimumDelay: UInt64 = 800_000_000 // 0.8 segundo
        
        async let delay = Task.sleep(minimumDelay)
        async let buscarCarregadosTask = persistence.generalSearch(prompt: prompt)
        
        do {
            let buscarCarregados = try await buscarCarregadosTask
            
            let _ = await delay
            
            generalSearch = buscarCarregados
            isSearchEmpty =
                buscarCarregados.0.isEmpty &&
                buscarCarregados.1.isEmpty &&
                buscarCarregados.2.isEmpty &&
                buscarCarregados.3.isEmpty
            
            print("\(buscarCarregados.0.count) usuários, \(buscarCarregados.1.count) grupos, \(buscarCarregados.2.count) desafios e \(buscarCarregados.3.count) tarefas carregados")
            
        } catch {
            print("Erro ao carregar resultados: \(error.localizedDescription)")
        }
        
        resultsLoaded = true
        isLoading = false
    }
}
