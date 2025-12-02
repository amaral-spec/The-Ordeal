

import SwiftUI

struct BigTaskCardView: View {
    @ObservedObject var resumoVM: ResumeViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(resumoVM.tasks.isEmpty ? .gray : Color("GreenCard"))
            if resumoVM.tasks.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.6)
                    .tint(.white)
            } else {
                VStack {
                    HStack {
                        Text("Tarefas")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Spacer()
                    
                    Image("custom.checklist.checked.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .frame(height: 220)
        .task {
            await resumoVM.carregarTarefas()
        }
    }
}

