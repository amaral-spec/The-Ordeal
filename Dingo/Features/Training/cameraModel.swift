//
//  cameraView.swift
//  camera
//
//  Created by João Victor Perosso Souza on 04/11/25.
//

import Foundation

import SwiftUI

// ---------------------------------------------------------------------------
// Estrutura que faz a ponte entre SwiftUI e UIKit para usar UIImagePickerController.
// UIImagePickerController é uma tela pronta do iOS para capturar fotos e vídeos.
// ---------------------------------------------------------------------------
struct ImagePicker: UIViewControllerRepresentable {
    // Define o tipo de fonte: pode ser câmera ou galeria.
    var sourceType: UIImagePickerController.SourceType = .camera//se quiser mudar para pegar pela galeria mude de .camera para .photoLibrary e no sheet do body tbm
    
    @Binding var selectedImage: UIImage?
    
    // Controla o fechamento da sheet (modal).
    @Environment(\.presentationMode) private var presentationMode
    
    // Cria o UIImagePickerController, que é uma view de UIKit.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController() // Instancia o controlador.
        picker.delegate = context.coordinator // Define o coordenador como delegado.
        picker.sourceType = sourceType // Define se usará a câmera ou galeria.
        picker.allowsEditing = false // Se quiser permitir corte/edição, mude para true.
        return picker // Retorna o controlador configurado.
    }
    
    // Atualiza o controlador se o SwiftUI mudar algo
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    // Cria o coordenador, responsável por lidar com callbacks do picker.
    func makeCoordinator() -> Coordinator {
        Coordinator(self) // Passa a instância do ImagePicker para o coordenador.
    }
    
    // Classe interna que implementa os protocolos de delegate do picker.
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent // Inicializa o coordenador com a referência.
        }
        
        // Função chamada quando o usuário tira uma foto ou escolhe uma imagem.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Extrai a imagem original (sem edição) do dicionário info.
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage // Armazena no @Binding do ContentView.
            }
            parent.presentationMode.wrappedValue.dismiss() // Fecha o picker.
        }
        
        // Função chamada quando o usuário cancela a operação.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss() // Fecha o picker.
        }
    }
}


