////
////  MeusGruposViewModel.swift
////  Dingo
////
////  Created by Ludivik de Paula on 09/12/25.
////
//
//
//import SwiftUI
//
//@MainActor
//class MeusGruposViewModel: ObservableObject {
//    @Published var groups: [GroupModel] = [] // Assumindo que GroupModel é o seu tipo de dado
//    @Published var isLoading: Bool = false
//    
//    let perfilVM: PerfilViewModel
//    
//    // Se você precisava do perfilVM antes para buscar, você pode injetar o serviço aqui
//    // ou mover a lógica do perfilVM para cá se for exclusiva dessa tela.
//    func loadGroups() async {
//        self.isLoading = true
//        
//         let fetchedGroups = await perfilVM.fetchAllGroups()
//         self.groups = fetchedGroups
//        
//        self.isLoading = false
//    }
//}
