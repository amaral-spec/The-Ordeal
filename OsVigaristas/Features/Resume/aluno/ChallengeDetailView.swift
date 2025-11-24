import SwiftUI

struct ChallengeDetailView: View {
    
    @EnvironmentObject var resumeVM: ResumeViewModel
    @EnvironmentObject var persistenceServices: PersistenceServices
    @State var startChallenge: Bool = false
    
    // MARK: - Example data (replace with real model)
    var daysRemaining: Int = 2
    var reward: Int = 50
    var descriptionText: String = "Descrição fornecida pelo próprio professor."
    var participants: [String] = Array(repeating: "person", count: 8)  // Replace with CK records
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Dados do Desafio")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                HStack(spacing: 16) {
                    infoCard(
                        title: daysRemaining > 0 ? "Faltam" : "Terminou",
                        value: "\(daysRemaining) Dias"
                    )
                    
                    infoCard(
                        title: "Prêmio",
                        value: "\(reward) Moedas"
                    )
                }
                .padding(.horizontal)
                
                // MARK: - Descrição
                VStack(alignment: .leading, spacing: 12) {
                    Text("Descrição")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(descriptionText)
                        .fixedSize(horizontal: false, vertical: true) // grows naturally
                        .foregroundStyle(.secondary)
                    
                }
                .padding()
                .background(.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 4)
                .padding(.horizontal)
                
                // MARK: - Participantes
                HStack {
                    Text("Participantes")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.accentColor)
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(participants.indices, id: \.self) { index in
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 70, height: 70)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // MARK: - Ação
                if resumeVM.isTeacher {
                    Text("Você é professor")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                } else {
                    Button {
                        startChallenge = true
                    } label: {
                        Text("Começar desafio")
                            .font(.headline)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
                Spacer(minLength: 30)
            }
            .padding(.top)
        }
        .background(Color(.systemGray6))
        .navigationTitle("Tarefa do Barquinho")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $startChallenge) {
            DoChallengeCoordinatorView()
        }
    }
    
    
    @ViewBuilder
    func infoCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.accentColor)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }

}


#Preview {
    // Instâncias para o Preview
    let services = PersistenceServices()
    let resumeVM = ResumeViewModel(persistenceServices: services, isTeacher: false)
    
    return NavigationStack {
        ChallengeDetailView()
            .environmentObject(resumeVM)
            .environmentObject(services)
    }
}
