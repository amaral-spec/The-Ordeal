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
    
    @EnvironmentObject private var authVM: AuthViewModel
    
    var body: some View {
        TabView() {
            Tab("Início", systemImage: "house") {
                VStack {
                    Text("Tela Principal (Logado)")
                }
            }
            Tab("Alunos", systemImage: "person.3") {
                Text("Alunos View")
            }
            Tab("Perfil", systemImage: "person.crop.circle") {
                VStack {
                    Text("Perfil View")
                    Button("Logout") {
                        authVM.logout()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
            Tab("Buscar", systemImage: "magnifyingglass", role: .search) {
                Text("Buscar View")
            }
        }
        .tint(Color(red: 0.65, green: 0.13, blue: 0.29))
        .searchable(text: $searchText)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Usuarios.self, inMemory: true)
        .environmentObject(AuthViewModel())
}
