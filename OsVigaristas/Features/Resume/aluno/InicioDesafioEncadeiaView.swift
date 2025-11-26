//
//  InicioDesafioEncadeiaView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI

struct InicioDesafioEncadeiaView: View {
    var body: some View {
       
            
            Spacer()
            VStack{//Escrita
               
                InstrucaoTopoPaginaView(instrucao: "Toque algo de sua escolha por 15 segundos")
                Spacer()
                
                
                ImagemIconeRosaView()
                
                MensagemDaImagemView(title: "Grave o seu audio", subtitle: "Faça milage")
                
                Spacer()
                Spacer()
                NavigationLink{
                    RecebeuAudioGravarDesafioEncadeiaView()
                }label:{
                    BotaoGravacaoView(color: .accentColor)

                }
            }
            .navigationTitle(Text("Encadeia"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
//                ToolbarItem(placement: .cancellationAction){
//                    Button("Cancelar", systemImage: "xmark")
//                    {
//                       // dismiss()
//                    }
//                }
//                ToolbarItem(placement: .confirmationAction){
//                    Button("confirmar", systemImage: "checkmark"){
//                        
//                    }
//                    .tint(Color(.gray))
//                    .
//                }
            }
        
    }
}







#Preview {
    InicioDesafioEncadeiaView()
}

