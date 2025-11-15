//
//  ProfessorDesafiosViewModel.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 14/11/25.
//

import Foundation
import CloudKit

final class ResumeViewModel: ObservableObject {
    @Published var challenges: [ChallengeModel]
    @Published var tasks: [TaskModel]
    @Published var isTeacher: Bool
    
    @Published var groupsByID: [CKRecord.ID : GroupModel] = [:]


    // Mock para listagem de desafios
    init(isTeacher: Bool = false) {
        self.isTeacher = isTeacher
        
        // MARK: - Criar mock de grupos com quantidade variável de membros
        func makeMockGroup(name: String, memberCount: Int) -> GroupModel {
            let group = GroupModel(name: name)
            group.members = (0..<memberCount).map { _ in
                CKRecord.Reference(
                    recordID: CKRecord.ID(recordName: UUID().uuidString),
                    action: .none
                )
            }
            return group
        }

        // Criando 2 grupos mockados
        let groupA = makeMockGroup(name: "Grupo A", memberCount: 12)
        let groupB = makeMockGroup(name: "Grupo B", memberCount: 27)

        // Convertendo GroupModel → CKRecord.Reference
        let groupARef = CKRecord.Reference(recordID: groupA.id, action: .none)
        let groupBRef = CKRecord.Reference(recordID: groupB.id, action: .none)

        // MARK: - Datas
        let now = Date()
        let inOneWeek = Calendar.current.date(byAdding: .day, value: 7, to: now) ?? now
        let inTwoWeeks = Calendar.current.date(byAdding: .day, value: 14, to: now) ?? now

        // MARK: - Mock Challenges
        self.challenges = [
            ChallengeModel(
                whichChallenge: 1,
                title: "Criar Quiz",
                description: "Monte um quiz para sua turma",
                group: groupARef, // agora tem 12 membros
                reward: 50,
                startDate: now,
                endDate: inOneWeek
            ),
            ChallengeModel(
                whichChallenge: 2,
                title: "Projeto Final",
                description: "Desenvolver app em SwiftUI",
                group: groupBRef, // agora tem 27 membros
                reward: 100,
                startDate: now,
                endDate: inTwoWeeks
            )
        ]

        // MARK: - Mock Tasks
        let dummyStudentID = CKRecord.ID(recordName: "dummy-student-id")
        let dummyStudentRef = CKRecord.Reference(recordID: dummyStudentID, action: .none)

        self.tasks = [
            TaskModel(
                title: "Corrigir provas",
                description: "Revisar e corrigir as avaliações dos alunos",
                student: dummyStudentRef,
                startDate: now,
                endDate: inOneWeek
            ),
            TaskModel(
                title: "Organizar feedbacks",
                description: "Compilar e enviar feedbacks individuais",
                student: dummyStudentRef,
                startDate: now,
                endDate: inOneWeek
            )
        ]
        
        self.groupsByID[groupA.id] = groupA
        self.groupsByID[groupB.id] = groupB
    }

}
