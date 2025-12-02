import SwiftUI

struct LoadingCardBase<T>: View {
    @ObservedObject var vm: CardLoaderViewModel<T>

    let title: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(vm.currentBackgroundColor))

            if vm.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.6)
                    .tint(.white)
            } else {
                VStack {
                    HStack {
                        Text(title)
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Spacer()

                    Image(vm.currentIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding()
            }
        }
        .frame(height: 200)
    }
}
