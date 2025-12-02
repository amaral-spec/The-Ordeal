import SwiftUI

struct BigChallengeCardView: View {

    @StateObject var vm: ChallengeCardVM
    @State private var abrirSheetCriar = false

    let navigationHandler: CardNavigationHandler
    let isTeacher: Bool

    init(resumoVM: ResumeViewModel, navigationHandler: CardNavigationHandler) {
        _vm = StateObject(wrappedValue: ChallengeCardVM(resumoVM: resumoVM))
        self.navigationHandler = navigationHandler
        self.isTeacher = resumoVM.isTeacher
    }

    var body: some View {
        LoadingCardBase(
            vm: vm.loader,
            title: "Desafio",
        )
        .onTapGesture { handleTap() }
        .task { await vm.load() }
        .sheet(isPresented: $abrirSheetCriar) {
            CriarDesafioView(numChallenge: .constant(0))
        }
    }

    // MARK: - Lógica Centralizada
    private func handleTap() {
        let empty = vm.loader.data.isEmpty

        if isTeacher {
            empty ? (abrirSheetCriar = true) : navigationHandler.navigateToChallengeList()
        } else {
            empty ? () : navigationHandler.navigateToChallengeList()
        }
    }
}
