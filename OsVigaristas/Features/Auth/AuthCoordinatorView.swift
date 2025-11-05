//
//  AuthCoordinatorView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 04/11/25.
//

import SwiftUI

struct AuthCoordinatorView: View {
    @State private var path: [AuthRoute] = []
    @StateObject private var authVM: AuthViewModel

    init() {
        _authVM = StateObject(wrappedValue: AuthViewModel(authService: AuthService.shared))
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            LoginView()
                .environmentObject(authVM)
                .onChange(of: authVM.isNewUser ?? false) { _, newValue in
                    if newValue {
                        path.append(.signUp)
                    }
                }
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .signUp:
                        SignUpView {
                            path.append(.terms)
                        }
                        .environmentObject(authVM)
                        .onDisappear {
                            authVM.isNewUser = nil
                        }

                    case .terms:
                        TermosView()
                            .onDisappear {
                                // Ao sair dos termos, pode finalizar o fluxo
                                path.removeAll()
                                authVM.isNewUser = false
                            }
                            .environmentObject(authVM)
                    }
                }
                .onAppear() {
                    authVM.checkStatus()
                }
        }
    }
}

enum AuthRoute: Hashable {
    case signUp
    case terms
}
