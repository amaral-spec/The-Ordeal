//
//  EditProfileSheetView.swift
//  OsVigaristas
//
//  Created by Júlio Zampietro on 25/11/25.
//

import SwiftUI
import CloudKit
import PhotosUI

struct EditProfileModal: View {
    @ObservedObject var vm: PerfilViewModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    
    @State private var selectedImage: UIImage? = nil
    @State private var photoItem: PhotosPickerItem? = nil
    @State private var needToCheckLoginAgain: Bool = false
    
    // 1. Estado para controlar o popup de confirmação
    @State private var showDiscardAlert: Bool = false
    
    private var isNameValid: Bool {
        !vm.editName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Foto de perfil")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 40)
                    
                    HStack {
                        PhotosPicker(
                            selection: $photoItem,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            if let img = selectedImage ?? vm.user?.profileImage {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .padding(.bottom, 40)
                            } else {
                                Image("partitura")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .padding(.bottom, 40)
                            }
                        }
                        .onChange(of: photoItem) { _, newValue in
                            Task {
                                await loadImage(from: newValue)
                            }
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Text("Informações")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        
                        Spacer()
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 350, height: 50)
                            .foregroundStyle(.white)
                        
                        HStack {
                            Text("Editar nome: ")
                                .fontWeight(.bold)
                                .padding(.leading, 40)
                            
                            TextField("Digite seu nome", text: $vm.editName)
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                        }
                    }
                    
                    if let validation = vm.editValidationError {
                        Text(validation)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.top, 4)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 350, height: 50)
                            .foregroundStyle(.white)
                        
                        Toggle("Sou professor", isOn: $vm.editIsTeacher)
                            .onChange(of: vm.editIsTeacher) {
                                needToCheckLoginAgain.toggle()
                            }
                            .fontWeight(.bold)
                            .padding(.horizontal, 40)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 350, height: 50)
                            .foregroundStyle(.white)
                        
                        Text("Logout")
                            .foregroundStyle(.red)
                    }
                    .padding(.top, 4)
                    .onTapGesture {
                        authService.cancelRegistration()
                    }
                }
                
            }
            .navigationTitle("Editar perfil")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    if vm.isSavingChanges {
                        ProgressView()
                    } else {
                        Button {
                            Task {
                                if let img = selectedImage {
                                    await vm.updateProfileImage(img)
                                }
                                await vm.saveUserEdits()
                                if vm.editValidationError == nil {
                                    if needToCheckLoginAgain {
                                        authService.changeType()
                                    }
                                    dismiss()
                                }
                            }
                        } label: {
                            Image(systemName: "checkmark")
                                .font(.body.bold())
                        }
                        .disabled(!isNameValid || vm.isSavingChanges)
                        .buttonStyle(.borderedProminent)
                        .tint(Color("BlueCard")) 
                    }
                }
                
                // 2. Botão de Cancelar alterado para ícone X e acionando o alerta
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        showDiscardAlert = true
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.bold())
                            .foregroundColor(.primary)
                    }
                }
            }
            .background(Color(.secondarySystemBackground))
            // 3. Alerta de confirmação destrutiva
            .alert("Descartar alterações?", isPresented: $showDiscardAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Descartar", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("Se você sair agora, suas alterações não serão salvas.")
            }
        }
    }
    
    private func loadImage(from item: PhotosPickerItem?) async {
        guard let item else { return }
        
        if let data = try? await item.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: data) {
            
            await MainActor.run {
                self.selectedImage = uiImage
            }
        }
    }
}
