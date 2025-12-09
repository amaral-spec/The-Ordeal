import SwiftUI

struct LoadingCardBase<T>: View {
    @ObservedObject var vm: CardLoaderViewModel<T>
    
    var sizeIcon: Int {
        vm.currentIcon.contains("badge.plus") ? 150 : 100
    }
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
                        .frame(width: CGFloat(sizeIcon), height: CGFloat(sizeIcon))
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding()
            }
        }
        .frame(height: 200)
    }
}
