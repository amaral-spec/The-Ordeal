import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    var onContinue: (() -> Void)? = nil

    @State private var nome: String = ""
    @State private var email: String = ""
    @State private var isProfessor: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Cadastro")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)

            VStack(spacing: 16) {
                TextField("Nome completo", text: $nome)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )

                TextField("E-mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )

                Toggle("Sou professor", isOn: $isProfessor)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .padding(.horizontal)

            Button(action: {
                viewModel.makeRegistration(isProfessor: isProfessor, nome: nome)
                onContinue?()
            }) {
                Text("Continuar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.65, green: 0.13, blue: 0.29))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    SignUpView()
}
