//
//  PerfilView.swift
//  OsVigaristas
//
//  Created by Jordana Lourenço Santos on 18/11/25.
//

import SwiftUI

struct PerfilStudentView: View {
    @EnvironmentObject var vm: PerfilViewModel
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showingEditSheet = false
    let onNavigate: (PerfilCoordinatorView.Route) -> Void
    
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
                    
                    //                    VStack(spacing: -20) {
                    Text(vm.user?.name ?? "Loading...")
                        .font(.title.bold())
                        .padding()
                    
                    VStack(spacing: -10) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 45)
                                .frame( height: 75)
                                .foregroundStyle(.white)
                            
                            HStack {
                                Image(systemName: "flame.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color("RedCard"))
                                
                                Text("\(vm.user?.streak ?? 0) dias de ofensiva!")
                                    .font(.title2)
                            }
                            .padding(.trailing, 90)
                        }
                        .padding(25)
                        
                        HStack(spacing: 15) {
                            CardPerfil(texto: "Última tarefa: \n\(vm.user?.lastTask?.endDate.formatted(date: .numeric, time: .omitted) ?? "Sem tarefa")")
                            CardPerfil(texto: "Último desafio: \n\(vm.user?.lastChallenge?.endDate.formatted(date: .numeric, time: .omitted) ?? "Sem desafio")")
                        }
                        .padding([.horizontal], 25)
                    }
                    
                    VStack(spacing: 16) {
                        
                        Row(texto: "Entrar em um grupo", hasArrow: false)
                            .onTapGesture {
                                vm.isShowingPopup = true
                                vm.resetGroupJoinState()
                            }
                        
                        Row(texto: "Meus grupos")
                            .onTapGesture {
                                onNavigate(.meusGrupos)
                            }
                        
                        Row(texto: "Sair", hasArrow: false, foregroundColor: .red, isCentered: true)
                            .onTapGesture {
                                authVM.logout()
                            }
                        
                    }
                    .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.secondarySystemBackground).ignoresSafeArea())
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
            
            .navigationTitle("Perfil")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Editar") {
                        // Só inicializa a edição com um valor não-vazio
                        let name = vm.user?.name ?? ""
                        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            vm.editName = ""
                        } else {
                            vm.editName = name
                        }
                        vm.editIsTeacher = vm.user?.isTeacher ?? false
                        showingEditSheet = true
                    }
                    .disabled(vm.user == nil) // Evita abrir antes de carregar
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
            RoundedRectangle(cornerRadius: 25)
                .frame( height: 100)
            //                .padding(5)
                .foregroundStyle(.white)
            
            Text(texto)
                .multilineTextAlignment(.leading)
        }
    }
}
import SwiftUI

struct Row: View {
    // 1. Mude de @State para let/var para permitir receber dados de fora
    let texto: String
    var hasArrow: Bool = true
    var foregroundColor: Color = .black
    var isCentered: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(height: 50)
                .padding(.horizontal, 25)
                .foregroundStyle(.white)
            
            // 2. Removido o parametro 'alignment' que estava com erro de sintaxe
            HStack {
                // Lógica de centralização usando Spacers
                if isCentered {
                    Spacer()
                }
                
                Text(texto)
                    .foregroundStyle(foregroundColor)
                
                // Se NÃO for centralizado, o Spacer fica entre o texto e a seta
                if !isCentered {
                    Spacer()
                }
                
                if hasArrow {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        // Se estiver centralizado com seta, dá um pequeno padding na seta
                        .padding(.leading, isCentered ? 8 : 0)
                }
                
                // Se for centralizado e NÃO tiver seta, precisamos de um Spacer no final para equilibrar
                if isCentered && !hasArrow {
                    Spacer()
                }
            }
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    VStack {
        Row(texto: "Opção Normal")
        Row(texto: "Opção Centralizada", hasArrow: false, foregroundColor: .red, isCentered: true)
        Row(texto: "Centralizada com Seta", hasArrow: true, isCentered: true)
    }
    .background(Color.gray.opacity(0.2))
}
