import SwiftUI

struct SolicitacaoCard: View {
    let user: UserModel
    let groupName: String
    let onAccept: () -> Void
    let onReject: () -> Void

    var body: some View {
        HStack(spacing: 12) {

            // FOTO (placeholder)
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)

                Text("Quer entrar no grupo \(groupName)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            // BOTÃO REJEITAR
            Button(action: onReject) {
                ZStack {
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: 32, height: 32)
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(.system(size: 14, weight: .bold))
                }
            }

            // BOTÃO ACEITAR
            Button(action: onAccept) {
                ZStack {
                    Circle()
                        .fill(Color.pink)
                        .frame(width: 32, height: 32)
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .bold))
                }
            }
        }
        .padding(.vertical, 6)
    }
}
