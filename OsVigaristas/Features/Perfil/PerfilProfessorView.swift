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
    
    init(persistenceServices: PersistenceServices) {
        _vm = StateObject(wrappedValue: PerfilViewModel(persistenceServices: persistenceServices))
    }
    
    var body: some View {
        VStack() {
            Spacer()
            
            Image("partitura")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding(30)
            
            Text(vm.user?.name ?? "Loading...")
                .font(.title)
            
            Spacer()
            
            Button {
                authVM.logout()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 350, height: 50)
                        .padding(10)
                        .foregroundStyle(Color("AccentColor").opacity(0.3))
                    
                    HStack {
                        Text("Logout")
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
        .navigationTitle("Perfil")
    }
}
