import Combine
import SwiftUI


@MainActor
final class CardLoaderViewModel<T>: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var data: [T] = []

    let isTeacher: Bool
    let iconNormal: String
    let iconEmpty: String
    let bgColorName: String

    private let loadAction: () async throws -> [T]

    init(
        iconNormal: String,
        iconEmpty: String,
        isTeacher: Bool,
        backgroundColor: String = "BlueCard",
        loadAction: @escaping () async throws -> [T]
    ) {
        self.iconNormal = iconNormal
        self.iconEmpty = iconEmpty
        self.loadAction = loadAction
        self.isTeacher = isTeacher
        self.bgColorName = backgroundColor
    }

    var currentIcon: String {
        if isLoading { return iconNormal }          // não importa o ícone enquanto carrega
        return data.isEmpty && isTeacher ? iconEmpty : iconNormal
    }
    
    var currentBackgroundColor: Color {
        return data.isEmpty ? Color(.gray) : Color(bgColorName)
    }

    func load() async {
        isLoading = true
        do {
            let result = try await loadAction()
            self.data = result
            print(self.data)
        } catch {
            print("Erro ao carregar card: \(error)")
            self.data = []
        }
        isLoading = false
    }
}
