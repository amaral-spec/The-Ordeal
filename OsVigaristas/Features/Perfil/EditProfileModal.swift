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
            Form {
                Section(header: Text("Foto de Perfil")) {
                    HStack {
                        Spacer()

                        PhotosPicker(
                            selection: $photoItem,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            if let img = selectedImage ?? vm.user?.profileImage {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            } else {
                                Image("partitura")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            }
                        }
                        .onChange(of: photoItem) { _, newValue in
                            Task {
                                await loadImage(from: newValue)
                            }
                        }

                        Spacer()
                    }
                }

                Section(header: Text("Informações")) {
                    TextField("Nome", text: $vm.editName)
                    Toggle("Sou professor", isOn: $vm.editIsTeacher)
                }
                
                Text("O app terá de ser reiniciado para que mudanças de papel (aluno/professor) sejam consideradas.")
                
            }
            .navigationTitle("Editar Perfil")
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
