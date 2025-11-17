//
//  ProfessorDesafiosViewModel.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 14/11/25.
//

import Foundation
import CloudKit

struct Grupo: Identifiable, Hashable {
    let id = UUID()
    let nome: String
}

final class ResumeViewModel: ObservableObject {
    @Published var challenges: [ChallengeModel] = []
    @Published var tasks: [TaskModel] = []
    @Published var isTeacher: Bool = true
    @Published var groupsByID: [CKRecord.ID : GroupModel] = [:]
    @Published private var isChallengesEmpty: Bool = true
    
    private let persistenceServices: PersistenceServices
    
    init(persistenceServices: PersistenceServices) {
        self.persistenceServices = persistenceServices
    }

    func carregarDesafios() async {
        do {
            let desafiosCarregados = try await persistenceServices.fetchAllChallenges()
            await MainActor.run {
                challenges = desafiosCarregados
                isChallengesEmpty = desafiosCarregados.isEmpty
                return challenges
            }
            print("\(desafiosCarregados.count) grupos carregados")
        } catch {
            print("Erro ao carregar grupos: \(error.localizedDescription)")
        }
    }
}
