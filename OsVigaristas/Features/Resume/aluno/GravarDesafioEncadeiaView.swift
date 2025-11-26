//
//  GravarDesafioEncadeiaView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI
import UIKit // For haptic feedback
import Combine
import AVFoundation


struct GravarDesafioEncadeiaView: View {
    var body: some View {
            
            Spacer()
            VStack{//Escrita
                InstrucaoTopoPaginaView(instrucao: "Toque algo de sua escolha por 15 segundos")
                
                
                Spacer()
          
                
                ReprentacaoAudioView()
                
                
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




#Preview {
    GravarDesafioEncadeiaView()
}

