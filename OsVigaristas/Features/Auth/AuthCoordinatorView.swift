//
//  AuthCoordinatorView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 04/11/25.
//

import SwiftUI

struct AuthCoordinatorView: View {
    @State private var path: [AuthRoute] = []
    @StateObject private var viewModel: AuthViewModel

    init() {
        _viewModel = StateObject(wrappedValue: AuthViewModel(authService: AuthService.shared))
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            LoginView()
                .environmentObject(viewModel)
                .onChange(of: viewModel.isNewUser ?? false) { _, newValue in
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
                        .environmentObject(viewModel)
                        .onDisappear {
                            viewModel.isNewUser = nil
                        }

                    case .terms:
                        TermosView()
                            .onDisappear {
                                // Ao sair dos termos, pode finalizar o fluxo
                                path.removeAll()
                                viewModel.isNewUser = false
                            }
                            .environmentObject(viewModel)
                    }
                }
                .onAppear() {
                    viewModel.checkStatus()
                }
        }
    }
}

enum AuthRoute: Hashable {
    case signUp
    case terms
}
