import SwiftUI

struct BigTaskCardView: View {

    @StateObject var vm: TaskCardVM
    @State private var abrirSheetCriar = false

    let navigationHandler: CardNavigationHandler
    let isTeacher: Bool

    init(resumoVM: ResumeViewModel, navigationHandler: CardNavigationHandler) {
        _vm = StateObject(wrappedValue: TaskCardVM(resumoVM: resumoVM))
        self.navigationHandler = navigationHandler
        self.isTeacher = resumoVM.isTeacher
    }

    var body: some View {
        LoadingCardBase(
            vm: vm.loader,
            title: "Tarefas",
        )
        .onTapGesture { handleTap() }
        .task { await vm.load() }
        .sheet(isPresented: $abrirSheetCriar) {
            CriarTarefaView(numTask: .constant(0))
        }
    }

    private func handleTap() {
        let empty = vm.loader.data.isEmpty

        if isTeacher {
            empty ? (abrirSheetCriar = true) : navigationHandler.navigateToTaskList()
        } else {
            empty ? () : navigationHandler.navigateToTaskList()
        }
    }
}
