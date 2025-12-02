
import SwiftUI

@MainActor
final class TaskCardVM: ObservableObject {
    @Published var loader: CardLoaderViewModel<TaskModel>

    init(resumoVM: ResumeViewModel) {
        self.loader = CardLoaderViewModel(
            iconNormal: "custom.checklist.checked.circle.fill",
            iconEmpty:  "custom.checklist.checked.circle.fill.badge.plus",
            isTeacher: resumoVM.isTeacher,
            backgroundColor: "GreenCard",
            loadAction: {
                await resumoVM.carregarTarefas()
                return resumoVM.tasks
            }
        )
    }

    func load() async { await loader.load() }
}
