//
//  PerfilProfessorVIew.swift
//  OsVigaristas
//
//  Created by Júlio Zampietro on 25/11/25.
//

import SwiftUI

struct PerfilProfessorView: View {
    @StateObject private var vm: PerfilViewModel
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showingEditSheet = false
    
    init(persistenceServices: PersistenceServices) {
        _vm = StateObject(wrappedValue: PerfilViewModel(persistenceServices: persistenceServices))
    }
    
    var body: some View {
        NavigationStack {
            VStack() {
                if let image = vm.user?.profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding()
                } else {
                    Image("partitura")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding()
                }
                
                Text(vm.user?.name ?? "Loading...")
                    .font(.title)
                    .padding()
                
                Text("Professor desde \(vm.user?.creationDate.formatted(date: .numeric, time: .omitted) ?? "Loading...")")
                    .font(.caption)
                    .padding()
                
                Button {
                    authVM.logout()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 350, height: 50)
                            .padding(10)
                            .foregroundStyle(Color("AccentColor").opacity(0.3))
                        
                        HStack {
                            Text("Sair")
                                .foregroundColor(.red)
                        }
                        .padding(.horizontal, 40)
                    }
                }
                Spacer()
            }
            .task { await vm.loadUser() }
            .navigationTitle("Perfil")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Editar") {
                        vm.editName = vm.user?.name ?? ""
                        vm.editIsTeacher = vm.user?.isTeacher ?? false
                        showingEditSheet = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditProfileModal(vm: vm)
        }
    }
}
