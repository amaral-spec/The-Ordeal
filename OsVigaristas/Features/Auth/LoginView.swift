import SwiftUI
import AuthenticationServices

struct LoginView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Usuarios]

    @EnvironmentObject private var authVM: AuthViewModel
    
    var body: some View {
        VStack() {
            ZStack {
                Circle()
                    .foregroundStyle(Color(red: 0.65, green: 0.13, blue: 0.29))
                    .frame(height: 130)
                    .padding()
                
                Image(systemName: "music.note")
                    .font(.system(size: 70))
                    .foregroundStyle(.white)
            }
            
            Text("Login or sign up")
                .font(.system(size: 30))
                .padding(.vertical, 90)
            
            SignInWithAppleButton(
                .signIn,
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

//#Preview {
//    LoginView()
//        .modelContainer(for: Usuarios.self, inMemory: true)
//        .environmentObject(AuthViewModel())
//}
