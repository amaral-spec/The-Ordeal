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
    
    @State private var selectedImage: UIImage? = nil
    @State private var photoItem: PhotosPickerItem? = nil  // NEW
    
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
                            .foregroundStyle(.gray.opacity(0.3))
                        
                        HStack {
                            Text("Editar nome: ")
                                .fontWeight(.bold)
                                .padding(.leading, 40)
                            
                            TextField("", text: $vm.editName)
                        }
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 350, height: 50)
                            .foregroundStyle(.gray.opacity(0.3))
                        
                        Toggle("Sou professor", isOn: $vm.editIsTeacher)
                            .fontWeight(.bold)
                            .padding(.horizontal, 40)
                    }
                }
                
                Text("O usuário terá de realizar login novamente para mudança de tipo de conta ser efetuada.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 40)
                
            }
            .navigationTitle("Editar perfil")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    if vm.isSavingChanges {
                        ProgressView()
                    } else {
                        Button("Salvar") {
                            Task {
                                if let img = selectedImage {
                                    await vm.updateProfileImage(img)
                                }
                                await vm.saveUserEdits()
                            }
                            dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
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
