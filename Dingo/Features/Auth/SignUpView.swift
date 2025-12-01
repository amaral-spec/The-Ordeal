import SwiftUI

struct SignUpView: View {
    var onContinue: (() -> Void)? = nil
    
    @EnvironmentObject var authVM: AuthViewModel
    @State private var nomeDeUsuario: String = ""
    @State private var isTeacher: Bool = false
    @State private var mostrarTermos: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    Image("Logo")
                        .scaleEffect(0.5)
                        .frame(height: 280)
                        .padding()
                }
                
                Text("Sing up")
                    .font(.system(size: 30))
                    .padding(.bottom, 50)
                
                TextField("Nome de usuário", text: $nomeDeUsuario)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.gray)
                    )
                    .padding(.horizontal)
                
                HStack {
                    Text("Você é um professor?")
                    Spacer()
                    Picker ("", selection: $isTeacher){
                        Text("Sim").tag(true)
                        Text("Não").tag(false)
                    }
                    .pickerStyle(.menu)
                    .tint(.black)
                }
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.gray)
                )
                .padding(.horizontal)
                
                
                Button(action: {
                    authVM.makeRegistration(isTeacher: isTeacher, name: nomeDeUsuario)
                    onContinue?()
                }) {
                    Text("Seguir para termos")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(50)
                }
                .padding(.horizontal)
                .padding(.top, 60)
            }
            .padding(.bottom, 60)
        }
    }
}

#Preview {
    SignUpView()
}
