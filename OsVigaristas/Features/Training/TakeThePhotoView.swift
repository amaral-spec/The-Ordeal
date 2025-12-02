 //
//  TakeThePhotoView.swift
//  CoreMLtest
//
//  Created by Júlio Zampietro on 28/10/25.
//

import SwiftUI
import PhotosUI

struct TakeThePhotoView: View {
    
    @EnvironmentObject var detector: InstrumentDetectionViewModel

    @State private var instrumentItem: UIImage? = nil
    @State private var showPicker = false
    //@State private var pickedImage: UIImage? // Armazena a imagem capturada pela câmera.
    @State private var isAInstrument: Bool = false
    
    let finalizarSheet: () -> Void
    
    var body: some View {
        VStack {
            //Titulo
            Text("Treino")
                .font(.system(size: 26, weight: .bold))
                .padding(.bottom, 30)
            
            Spacer()
            //Mostra a imagem se ela existir
            mostraImagem()
            
            Spacer()
            
            //Botao de tirar foto || finalizar
            Button(action: {
                
                showPicker = true
                
                
            }) {
            
                //Botao para tirar foto
                if(isAInstrument == false){
                    ZStack {
                        Circle()
                            .frame(height: 80)
                            .foregroundColor(Color("AccentColor"))
                        
                        Image(systemName: "camera")
                            .fontWeight(.bold)
                        //.frame(width: 200, height: 50)
                            .font(Font.largeTitle.bold())
                            .foregroundColor(Color.white)
                            .padding()
                    }
                }else { //Botao para fechar a view e concluir o treino
                    
                }
                   
            }
        }
        .padding()
        

        //Mostra a camera
        .sheet(isPresented: $showPicker) {
            // Chama o ImagePicker, definindo que a fonte é a câmera.
            ImagePicker(sourceType: .camera, selectedImage: $instrumentItem)//se quiser mudar para pegar pela galeria mude de .camera para .photoLibrary
            
        }
        
        .onChange(of: instrumentItem) {
            if let image = instrumentItem{
                detector.selectedImage = image   // <-- ADICIONE ISSO

                Task {
                  detector.detect(image: image)
                }
            }
        }
    
        //Quando o instrumento é identificado, isAnInstrument = true
        .onChange(of: detector.classificationLabel){
            if(detector.classificationLabel == "Instrumento identificado!"){
                isAInstrument = true
            }
        }
        .onChange(of: instrumentItem) {
            print("Chegou imagem:", instrumentItem != nil)
        }
        
        .toolbar{
            ToolbarItem(placement: .confirmationAction){
                Button("confirmar", systemImage: "checkmark"){
                    if(isAInstrument)
                    {
                        finalizarSheet()
                    }
                }
                //.tint(Color(.blue))
                .tint(isAInstrument ? Color("AccentColor") : Color(.gray))
            }
        }
    }
}

struct mostraImagem: View{
    @EnvironmentObject var detector: InstrumentDetectionViewModel
    var body: some View {
        if let selectedImage = detector.selectedImage {
            Image(uiImage: selectedImage)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .cornerRadius(12)
                .padding(.horizontal)
            
            //Resultado da analise
            Text(detector.classificationLabel)
                .font(.title2)
                .padding()
        } else {
            //Figurinha de fotos
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 200))
                .foregroundColor(.gray.opacity(0.3))
                .padding()
            //"Select an image to classify"
            Text(detector.classificationLabel)
                .font(.title2)
                .padding()
        }
    }
}
#Preview {
    TakeThePhotoView(finalizarSheet: {})
        .environmentObject(InstrumentDetectionViewModel())

}
