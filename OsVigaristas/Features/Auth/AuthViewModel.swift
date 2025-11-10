import SwiftUI
import AuthenticationServices

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var isNewUser: Bool?  = false
    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }
    
    func handle(_ result: Result<ASAuthorization, Error>) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let loginResult = try await authService.handleAppleSignIn(result: result)
                isNewUser = loginResult == .newUser
            } catch {
                errorMessage = "Falha no login: \(error.localizedDescription)"
            }

            isLoading = false
        }
    }

    func checkStatus() {
        authService.checkAppleSignInStatus()
    }
    
    func finishRegistration() {
        authService.finishRegistration()
    }
    
    func makeRegistration(isProfessor: Bool, nome: String) {
        authService.makeRegistration(isProfessor: isProfessor, nome: nome)
    }

    func logout() {
        authService.logout()
    }
}
