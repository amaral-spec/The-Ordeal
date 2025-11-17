//
//  RecebeuAudioGravarDesafioEncadeiaView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI
import UIKit // For haptic feedback
import Combine
import AVFoundation


struct RecebeuAudioGravarDesafioEncadeiaView: View {
    var body: some View {
        NavigationStack{
            
            Spacer()
            VStack{//Escrita
                
                InstrucaoTopoPaginaView(instrucao: """
                    Grave uma continuação de 
                    15 segundos para o audio abaixo
                    """)
                
                Spacer()
          
                
                ReprentacaoAudioView()
                    .padding(.trailing, 30)
                    //.shadow(color: .gray, radius: 10)
                Spacer()
                ImagemIconeRosaView()
                MensagemDaImagemView(title: "Grave o seu audio", subtitle: "Faça milage")
                Spacer()
                Spacer()
                
                BotaoGravacaoView(color: .accentColor)
                
            }
            .navigationTitle(Text("Encadeia"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
//                ToolbarItem(placement: .cancellationAction){
//                    Button("Cancelar", systemImage: "xmark")
//                    {
//                        //dismis()
//                    }
//                }
//                ToolbarItem(placement: .confirmationAction){
//                    Button("confirmar", systemImage: "checkmark"){
//                        
//                    }
//                    .tint(Color("AccentColor"))
//                }
            }
        }
    }
}




#Preview {
    RecebeuAudioGravarDesafioEncadeiaView()
}

