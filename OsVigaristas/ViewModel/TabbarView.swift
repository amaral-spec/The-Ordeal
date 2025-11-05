//
//  TabBarView.swift
//  OsVigaristas
//
//  Created by Erika Hacimoto on 04/11/25.
//

import SwiftUI

struct TabbarView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("Início", systemImage: "house", value: 0) {
                HomeView()
            }
            Tab("Alunos", systemImage: "person.3", value: 1) {
                HomeView()
            }
            Tab("Perfil", systemImage: "person.crop.circle", value: 2) {
                HomeView()
            }
            Tab("Search", systemImage: "magnifyingglass", value:3, role: .search) {
                HomeView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    TabbarView()
}

//
//struct TabExampleView: View {
//    @State private var text: String = ""
//
//
//    var body: some View {
//        TabView {
//            Tab("Books", systemImage: "book") {
//                HomeView()
//            }
//            Tab(role: .search) {
//                NavigationStack {
//                    HomeView()
//                }
//            }
//        }
//        .searchable(text: $text)
//        .tabViewSearchActivation(.searchTabSelection)
//    }
//}
