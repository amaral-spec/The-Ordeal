import SwiftUI
import CloudKit

struct SolicitacaoCard: View {
    let user: UserModel
    let groupName: String
    let onAccept: () -> Void
    let onReject: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if let uiImage = user.profileImage {
                    Image(uiImage: uiImage)
                        .resizable()
                }
//                } else {
//                    Image("partitura")
//                        .resizable()
//                }
            }
            .scaledToFill()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text("Quer entrar no grupo:\n\(groupName)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .layoutPriority(1)

            HStack(spacing: 12) {
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
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
                .buttonStyle(.plain)
                .accessibilityLabel("Rejeitar solicitação")

                Button(action: onAccept) {
                    ZStack {
                        Circle()
                            .fill(Color("BlueCard"))
                            .frame(width: 32, height: 32)
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                    }
                }
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
                .buttonStyle(.plain)
                .accessibilityLabel("Aceitar solicitação")
            }
            .fixedSize()
        }
        .padding(.vertical, 8)
    }
}
