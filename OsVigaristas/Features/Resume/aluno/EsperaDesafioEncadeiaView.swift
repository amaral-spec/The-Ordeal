//
//  EaperaDesafioEncadeiaView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI

struct EsperaDesafioEncadeiaView: View {
    var body: some View {
            
            
            VStack{//Escrita
                
                Spacer()
                
                ImagemIconeRosaEsperaView(nomeIcone: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                
                //.padding()
                MensagemDaImagemView(title: "Em espera", subtitle: "Outra pessoas está gravando,\nespere o desafio estar livre\npara começar")
                
                
                Spacer()
                //botaoGravacao(color: .gray)
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
                
            }
        
    }
}







#Preview {
    EsperaDesafioEncadeiaView()
}

