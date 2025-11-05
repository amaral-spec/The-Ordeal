import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject private var viewModel: AuthViewModel

    var body: some View {
        VStack {
            Rectangle()
                .foregroundStyle(Color(red: 0.65, green: 0.13, blue: 0.29))
                .frame(height: 150)

            Text("Login ou Cadastro")
                .font(.title2)
                .padding(.bottom, 50)

            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                viewModel.handle(result)
            }
            .frame(height: 45)
            .padding()
            .signInWithAppleButtonStyle(.black)

            if viewModel.isLoading {
                ProgressView("Entrando...")
                    .padding(.top)
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }

            Spacer()
        }
        .background(Color.white)
        .ignoresSafeArea()
    }
}
