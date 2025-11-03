//
//  ContentView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 27/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var usuarios: [Usuarios]
    @State private var searchText: String = ""
    
    var body: some View {
        TabView() {
            Tab("Início", systemImage: "house") {
                LoginView()
            }
            Tab("Alunos", systemImage: "person.3") {
                //alunos view
            }
            Tab("Perfil", systemImage: "person.crop.circle") {
                //perfil view
            }
            Tab("Buscar", systemImage: "magnifyingglass", role: .search) {
                //buscar view
            }
        }
        .foregroundStyle(Color(red: 0.65, green: 0.13, blue: 0.29))
        .searchable(text: $searchText)
    }
}
    

#Preview {
    ContentView()
        .modelContainer(for: Usuarios.self, inMemory: true)
}
