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
    @Published private var isChallengeEmpty: Bool = true
    @Published private var isTaskEmpty: Bool = true
    
    private let persistenceServices: PersistenceServices
    
    init(persistenceServices: PersistenceServices, isTeacher: Bool = false) {
        self.persistenceServices = persistenceServices
        self.isTeacher = isTeacher
    }

    func carregarDesafios() async {
        do {
            let desafiosCarregados = try await persistenceServices.fetchAllChallenges()
            await MainActor.run {
                challenges = desafiosCarregados
                isChallengeEmpty = desafiosCarregados.isEmpty
            }
            print("\(desafiosCarregados.count) desafios carregados")
        } catch {
            print("Erro ao carregar desafios: \(error.localizedDescription)")
        }
    }
    
    func carregarGrupo(reference: CKRecord.Reference) async throws -> GroupModel{
        let grupo = try await persistenceServices.fetchGroup(recordID: reference.recordID)
        return grupo
    }
    
    func carregarTarefas() async {
        do {
            let tarefasCarregadas = try await persistenceServices.fetchAllTasks()
            await MainActor.run {
                tasks = tarefasCarregadas
                isTaskEmpty = tarefasCarregadas.isEmpty
            }
            print("\(tarefasCarregadas.count) tarefas carregadas")
        } catch {
            print("Erro ao carregar tarefas: \(error.localizedDescription)")
        }
    }
}
