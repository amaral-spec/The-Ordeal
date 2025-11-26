

import SwiftUI

struct ChallengeCoordinatorStudentView: View {
    @State private var path: [ChallengeCoordinatorStudendRoute] = []
    @StateObject private var ChallengeCoordinatorStudendVM: ChallengeCoordinatorStudendViewModel

    init() {
        _ChallengeCoordinatorStudendVM = StateObject(wrappedValue: ChallengeCoordinatorStudendViewModel(ChallengeCoordinatorStudendService: ChallengeCoordinatorStudendService.shared))
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            LoginView()
                .environmentObject(ChallengeCoordinatorStudendVM)
                .onChange(of: ChallengeCoordinatorStudendVM.isNewUser ?? false) { _, newValue in
                    if newValue {
                        path.append(.signUp)
                    }
                }
                .navigationDestination(for: ChallengeCoordinatorStudendRoute.self) { route in
                    switch route {
                    case .signUp:
                        SignUpView {
                            path.append(.terms)
                        }
                        .environmentObject(ChallengeCoordinatorStudendVM)
                        .onDisappear {
                            ChallengeCoordinatorStudendVM.isNewUser = nil
                        }

                    case .terms:
                        TermosView()
                            .onDisappear {
                                // Ao sair dos termos, pode finalizar o fluxo
                                path.append(.signUp)
                                ChallengeCoordinatorStudendVM.isNewUser = false
                            }
                            .environmentObject(ChallengeCoordinatorStudendVM)
                    }
                }
                .onAppear() {
                    ChallengeCoordinatorStudendVM.checkStatus()
                }
        }
    }
}

enum ChallengeCoordinatorStudendRoute: Hashable {
    case signUp
    case terms
}
