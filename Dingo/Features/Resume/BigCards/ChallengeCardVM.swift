
import SwiftUI

@MainActor
final class ChallengeCardVM: ObservableObject {
    @Published var loader: CardLoaderViewModel<ChallengeModel>

    init(resumoVM: ResumeViewModel) {
        self.loader = CardLoaderViewModel(
            iconNormal: "custom.flag.pattern.checkered.2.crossed.circle.fill",               // ícone normal
            iconEmpty:  "custom.flag.pattern.checkered.2.crossed.circle.fill.badge.plus",    // ícone quando vazio
            isTeacher: resumoVM.isTeacher,
            backgroundColor: "BlueCard",
            loadAction: {
                await resumoVM.carregarDesafios()
                return resumoVM.challenges
            }
        )
    }

    func load() async { await loader.load() }
}
