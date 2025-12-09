import SwiftUI
import AuthenticationServices

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var isNewUser: Bool?  = false

    let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }
    
    func handle(_ result: Result<ASAuthorization, Error>) {
        errorMessage = nil

        Task {
            do {
                let loginResult = try await authService.handleAppleSignIn(result: result)
                isNewUser = loginResult == .newUser
            } catch {
                errorMessage = "Falha no login: \(error.localizedDescription)"
            }

        }
    }

    func checkStatus() {
        authService.checkAppleSignInStatus()
    }
    
    func finishRegistration() {
        authService.finishRegistration()
    }
    
    func makeRegistration(isTeacher: Bool, name: String) {
        authService.makeRegistration(isTeacher: isTeacher, name: name)
    }

    func logout() {
        authService.logout()
    }
}
