import SwiftUI
import AuthenticationServices

struct LoginView: View {
    //    @Environment(\.modelContext) private var modelContext
    //    @Query private var items: [Usuarios]
    
    @EnvironmentObject private var authVM: AuthViewModel
    
    var body: some View {
        VStack {
            ZStack {
                Image("Logo")
                    .scaleEffect(0.5)
                    .frame(height: 150)
                    .padding()
            }
            
            Text("Seja bem vindo ao Dingo\n")
                .font(.system(size: 30))
                .padding(.vertical, 16)
            
            
            SignInWithAppleButton(
                .continue,
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    authVM.handle(result)
                }
            )
            .cornerRadius(50)
            .frame(height: 50)
            .padding()
            .signInWithAppleButtonStyle(.black)
            
        }
        .onAppear {
            authVM.checkStatus()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // <--- O SEGREDO
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel(authService: AuthService.shared))
}

//#Preview {
//    LoginView()
//        .modelContainer(for: Usuarios.self, inMemory: true)
//        .environmentObject(AuthViewModel())
//}
