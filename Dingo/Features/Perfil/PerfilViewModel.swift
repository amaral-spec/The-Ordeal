//
//  PerfilViewModel.swift
//  OsVigaristas
//
//  Created by Júlio Zampietro on 24/11/25.
//

import SwiftUI
import CloudKit
import Combine

@MainActor
class PerfilViewModel: ObservableObject {
    // Profile properties
    @Published var user: UserModel?
    @Published var lastTaskDate: Date?
    @Published var lastChallengeDate: Date?
    @Published var points: Int = 0
    @Published var streak: Int = 0
    
    // Group joining properties
    @Published var isShowingPopup: Bool = false
    @Published var groupCodeInput: String = "" // Used for TextField binding
    @Published var fetchedGroup: GroupModel? = nil
    @Published var fetchError: String? = nil
    @Published var isJoiningGroup: Bool = false
    @Published var joinSuccessMessage: String? = nil
    @Published var joinErrorMessage: String? = nil
    @Published var didSendSolicitation: Bool = false
    @Published var failedSendSolicitation: Bool = false
    
    // Profile editing properties
    @Published var isShowingEditProfile: Bool = false
    @Published var editName: String = ""
    @Published var editIsTeacher: Bool = false
    @Published var isSavingChanges: Bool = false
    @Published var editValidationError: String? = nil
    
    private let persistenceServices: PersistenceServices
    private var groupCodeCancellable: AnyCancellable? // For debouncing
    
    init(persistenceServices: PersistenceServices) {
        self.persistenceServices = persistenceServices
        setupGroupCodeObserver() // Initialize the debouncer
    }
    
    func loadUser() async {
        do {
            let fetchedUser = try await persistenceServices.fetchUserForProfile()
            
            print("Usuario coletado com sucesso: \(fetchedUser)")
            
            self.user = fetchedUser
            
            self.points = fetchedUser.points
            self.streak = fetchedUser.streak
            self.lastTaskDate = fetchedUser.lastTask?.endDate
            self.lastChallengeDate = fetchedUser.lastChallenge?.endDate
            
        } catch {
            print("Failed to load user: \(error)")
        }
    }

    private func setupGroupCodeObserver() {
        groupCodeCancellable = $groupCodeInput
            // Only search if the popup is visible and code is not empty
            .filter { [weak self] _ in self?.isShowingPopup == true }
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] code in
                guard let self = self else { return }
                
                // Reset state for new search
                self.fetchedGroup = nil
                self.fetchError = nil
                
                if code.isEmpty { return }
                
                Task { await self.fetchGroup(code: code) }
            }
    }
    
    func fetchGroup(code: String) async {
        // Clear old messages
        joinSuccessMessage = nil
        joinErrorMessage = nil
        
        do {
            self.fetchedGroup = try await persistenceServices.fetchGroupByCode(code: code)
            self.fetchError = nil
            if self.fetchedGroup == nil && !code.isEmpty {
                 self.fetchError = "Nenhum grupo encontrado com este código."
            }
        } catch {
            self.fetchedGroup = nil
            self.fetchError = "Erro ao buscar grupo: \(error.localizedDescription)"
        }
    }
    
    func askToJoinGroup() async {
        guard let group = fetchedGroup else {
            joinErrorMessage = "Erro: Grupo não encontrado."
            return
        }
        
        isJoiningGroup = true
        joinSuccessMessage = nil
        joinErrorMessage = nil
        
        do {
            try await persistenceServices.askToJoinGroup(to: group)
            joinSuccessMessage = "Solicitação enviada com sucesso para o grupo \(group.name)!"
            
            withAnimation {
                didSendSolicitation = true
            }
            
            // Removes feedback after 2.0 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.didSendSolicitation = false
                }
            }
            
            // Haptics
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            isShowingPopup = false // Close alert on success
            resetGroupJoinState()
        } catch {
            joinErrorMessage = "Falha ao enviar solicitação: \(error.localizedDescription)"
            
            withAnimation {
                failedSendSolicitation = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.failedSendSolicitation = false
                }
            }
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            isShowingPopup = false
            resetGroupJoinState()
        }
        
        isJoiningGroup = false
    }
    
    func resetGroupJoinState() {
        groupCodeInput = ""
        fetchedGroup = nil
        fetchError = nil
        isJoiningGroup = false
        // Keep joinSuccessMessage/joinErrorMessage to display after alert closes
    }

    func updateProfileImage(_ image: UIImage) async {
        do {
            try await persistenceServices.updateProfileImage(image)
            user?.profileImage = image
        } catch {
            print("Failed updating image: \(error)")
        }
    }

    func saveUserEdits() async {
        guard !isSavingChanges else { return }
        
        let trimmed = editName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            editValidationError = "O nome não pode ser vazio."
            return
        }
        editValidationError = nil
        isSavingChanges = true

        do {
            try await persistenceServices.editUser(
                newName: trimmed,
                isTeacher: editIsTeacher
            )

            // Update UI locally
            user?.name = trimmed
            user?.isTeacher = editIsTeacher

            isShowingEditProfile = false
        } catch {
            print("Failed to edit user: \(error)")
        }

        isSavingChanges = false
    }

}
