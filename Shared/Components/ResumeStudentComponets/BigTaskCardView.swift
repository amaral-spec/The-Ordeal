

import SwiftUI

struct BigTaskCardView: View {
    @ObservedObject var resumoVM: ResumeViewModel

    var body: some View {
        ZStack {
            if resumoVM.tasks.isEmpty {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.gray)
            } else {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color("GreenCard"))
            }

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
        .frame(height: 220)
        .task {
            await resumoVM.carregarTarefas()
        }
    }
}
