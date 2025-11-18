//
//  AlunosCoordinatorView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 18/11/25.
//


import SwiftUI



struct AlunosCoordinatorView: View {
    
    enum Route: Equatable, Hashable {
        case list
        case detailGroup(GroupModel)
        case solicitation
    }
    
    @EnvironmentObject var persistenceServices: PersistenceServices
    @StateObject private var viewModel: AlunosViewModel
    @State private var path: [Route] = []
    
    init() {
        _viewModel = StateObject(wrappedValue: AlunosViewModel(persistenceServices: PersistenceServices.shared))
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            AlunosView(alunoVM: viewModel) { route in
                self.path.append(route)
            }
            .onAppear {
                Task { await viewModel.groupLoad(); await viewModel.studentsLoad() }
            }
            .environmentObject(persistenceServices)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .detailGroup(groupModel):
                    DetailGroupView(grupo: groupModel)
                case .list:
                    EmptyView()
                case .solicitation:
                    Solicitacoes() // trocar para a view de solicitacoes
                }
            }
        }
    }
}
