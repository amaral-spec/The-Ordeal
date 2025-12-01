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
            VStack {
                ScrollView {
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
                    
                    VStack(spacing: -20) {
                        Text(vm.user?.name ?? "Loading...")
                            .font(.title.bold())
                            .padding()
                        
                        Text("Professor desde \(vm.user?.creationDate.formatted(date: .numeric, time: .omitted) ?? "Loading...")")
                            .font(.callout)
                            .foregroundStyle(Color.accentColor)
                            .padding()
                    }
                    
                    Button {
                        authVM.logout()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 350, height: 50)
                                .padding(10)
                                .foregroundStyle(Color.white)
                            
                            HStack {
                                Text("Sair")
                                    .foregroundColor(.red)
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.secondarySystemBackground).ignoresSafeArea())
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
}

#Preview {
    PerfilProfessorView(persistenceServices: PersistenceServices.shared)
}
