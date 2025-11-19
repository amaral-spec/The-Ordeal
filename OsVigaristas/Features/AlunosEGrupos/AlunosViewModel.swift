//
//  AlunosViewModel.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 18/11/25.
//


import SwiftUI
import CloudKit
import Foundation

enum Mode: String, CaseIterable {
    case Alunos = "Alunos"
    case Grupos = "Grupos"
}

class AlunosViewModel: ObservableObject {
    @Published var selectedMode: Mode = .Alunos
    @Published var students: [UserModel] = []
    @Published var isStudentsEmpty: Bool = true
    @Published var isGroupsEmpty: Bool = true
    @Published var grupos: [GroupModel] = []
    @Published var criarGrupo: Bool = false

    private let persistenceServices: PersistenceServices   // agora é apenas referência externa

    init(persistenceServices: PersistenceServices) {
        self.persistenceServices = persistenceServices
    }
    
    func studentsLoad() async {
        do {
            let studentsLoaded = try await persistenceServices.fetchAllStudents()
            await MainActor.run {
                self.students = studentsLoaded
                self.isStudentsEmpty = studentsLoaded.isEmpty
                print("Carregado \(studentsLoaded.count) alunos")
            }
        } catch {
            print("Erro ao carregar alunos: \(error.localizedDescription)")
        }
    }

    func groupLoad() async {
        do {
            let gruposCarregados = try await persistenceServices.fetchAllGroups()
            await MainActor.run {
                self.grupos = gruposCarregados
                self.isGroupsEmpty = gruposCarregados.isEmpty
                print("Carregado \(gruposCarregados.count) grupos")
            }
        } catch {
            print("Erro ao carregar grupos: \(error.localizedDescription)")
        }
    }
    
    func loadSolicitations() async {
        do {
            let solicitacoes = try await persistenceServices.fetchSolicitations()
        } catch {
            print("Erro ao carregar solicitações: \(error)")
        }
    }
    
    
}
