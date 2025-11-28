//
//  ProfessorDesafiosViewModel.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 14/11/25.
//

import Foundation
import CloudKit

final class ResumeViewModel: ObservableObject {
    @Published var challenges: [ChallengeModel] = []
    @Published var tasks: [TaskModel] = []
    @Published var challengeGroups: [ ChallengeModel : String ] = [:]
    
    @Published var isTeacher: Bool = false
    
    @Published var groupsByID: [CKRecord.ID : GroupModel] = [:]
    @Published private var isChallengeEmpty: Bool = true
    @Published private var isTaskEmpty: Bool = true
    @Published private var isMemberEmpty: Bool = true
    
    private let persistenceServices: PersistenceServices
    
    init(persistenceServices: PersistenceServices, isTeacher: Bool) {
        self.persistenceServices = persistenceServices
        self.isTeacher = isTeacher
    }

    func carregarDesafios() async {
        var challengeGroupsDict: [ChallengeModel : String] = [:]

        do {
            let desafiosCarregados = try await persistenceServices.fetchAllChallenges()
            
            for desafio in desafiosCarregados {
                let groupByChallenge = try await persistenceServices.fetchGroup(recordID: desafio.group!.recordID)
                challengeGroupsDict[desafio] = groupByChallenge.name
            }
            
            await MainActor.run {
                challengeGroups = challengeGroupsDict
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
    
    func carregarParticipantesPorDesafio(challenge: ChallengeModel) async {
        do {
            let participantesCarregados = try await persistenceServices.fetchChallengeMembers(recordReference: challenge.group!)
            await MainActor.run {
                members = participantesCarregados
                isMemberEmpty = participantesCarregados.isEmpty
            }
            print("\(participantesCarregados.count) participantes carregados")
        } catch {
            print("Erro ao carregar participantes: \(error.localizedDescription)")
        }
    }
    
    func formatarDiaMes(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter.string(from: date)
    }

    func diasRestantes(ate endDate: Date) -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let end = calendar.startOfDay(for: endDate)
        return calendar.dateComponents([.day], from: start, to: end).day ?? 0
    }
}
