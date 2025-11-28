//
//  PerfilView.swift
//  OsVigaristas
//
//  Created by Jordana Lourenço Santos on 18/11/25.
//

import SwiftUI

struct PerfilView: View {
    @StateObject private var vm: PerfilViewModel
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showingEditSheet = false
    
    init(persistenceServices: PersistenceServices) {
        _vm = StateObject(wrappedValue: PerfilViewModel(persistenceServices: persistenceServices))
    }
    
    var body: some View {
        NavigationStack {
            VStack(){
                ScrollView(){
                    if let image = vm.user?.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .padding(.top, 30)
                    } else {
                        Image("partitura")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .padding(.top, 30)
                    }
                    
                    Text(vm.user?.name ?? "Loading...")
                        .font(.title)
                    
                    Text("Aluno desde \(vm.user?.creationDate.formatted(date: .numeric, time: .omitted) ?? "Loading...")")
                        .font(.caption)
                        .foregroundColor(Color.accentColor)
                    
                    HStack{
                        CardPerfil(texto: "\(vm.user?.points ?? 0) B")
                        CardPerfil(texto: "\(vm.user?.streak ?? 0) F")
                    }
                    .padding(.top, 20)
                    
                    HStack{
                        CardPerfil(texto: "Última tarefa: \n\(vm.user?.lastTask?.endDate.formatted(date: .numeric, time: .omitted) ?? "No data")")
                        CardPerfil(texto: "Último desafio: \n\(vm.user?.lastChallenge?.endDate.formatted(date: .numeric, time: .omitted) ?? "No data")")
                    }
                    
                    Button {
                        vm.isShowingPopup = true
                        vm.resetGroupJoinState()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 350, height: 50)
                                .padding(10)
                                .foregroundStyle(Color.accentColor.opacity(0.3))
                            
                            HStack {
                                Text("Entrar em um grupo")
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                    .alert("Solicitar entrada em um grupo", isPresented: $vm.isShowingPopup) {
                        TextField("Código do grupo", text: $vm.groupCodeInput)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                        
                        Button(action: {
                            Task { await vm.askToJoinGroup() }
                        }) {
                            Text(vm.isJoiningGroup ? "Aguarde..." : "Entrar")
                        }
                        .disabled(vm.fetchedGroup == nil || vm.isJoiningGroup)
                        
                        Button("Cancelar", role: .cancel) {
                            vm.resetGroupJoinState()
                        }
                    }
                    message: {
                        // Display the dynamic message based on ViewModel state
                        if vm.isJoiningGroup {
                            Text("Aguarde, enviando solicitação...")
                        } else if let group = vm.fetchedGroup {
                            Text("Grupo encontrado: **\(group.name)**. Clique em Entrar para enviar a solicitação.")
                        } else if let error = vm.fetchError {
                            Text("**Erro:** \(error)")
                        } else if vm.groupCodeInput.isEmpty {
                            Text("Digite o código único do grupo.")
                        } else {
                            Text("Procurando grupo...")
                        }
                    }
                    
                    Button(action:{}){
                        Row(texto: "Histórico de tarefas")
                    }
                    .buttonStyle(.plain)
                    
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
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                }
            }
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
        .task {
            await vm.loadUser()
        }
        .sheet(isPresented: $showingEditSheet) {
            EditProfileModal(vm: vm)
        }
        .overlay(alignment: .top) {
            if vm.didSendSolicitation {
                Text("Solicitação enviada!")
                    .font(.headline)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color("BlueCard"))
                    .cornerRadius(30)
                    .padding(.top, 40)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(duration: 0.4), value: vm.didSendSolicitation)
            } else if vm.failedSendSolicitation {
                Text("Erro ao enviar solicitação")
                    .font(.headline)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color("RedCard"))
                    .cornerRadius(30)
                    .padding(.top, 40)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(duration: 0.4), value: vm.didSendSolicitation)
            }
        }
    }
}

struct CardPerfil: View {
    @State var texto: String
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 150, height: 100)
                .padding(10)
                .foregroundStyle(.gray.opacity(0.3))
            
            Text(texto)
                .multilineTextAlignment(.center)
        }
    }
}

struct Row: View {
    @State var texto: String
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 350, height: 50)
                .padding(10)
                .foregroundStyle(.gray.opacity(0.3))
            
            HStack {
                Text(texto)
                
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }.padding(.horizontal, 40)
        }
    }
}


