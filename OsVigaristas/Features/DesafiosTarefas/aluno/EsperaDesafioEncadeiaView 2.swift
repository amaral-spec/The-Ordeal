//
//  EaperaDesafioEncadeiaView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI

struct EaperaDesafioEncadeiaView: View {
    var body: some View {
        NavigationStack{
            
            Spacer()
            VStack{//Escrita
                Text("Toque algo de sua escolha por 15 segundos")
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title3.bold())
                Spacer()
                
                ZStack{ //Imagem no meio estranha
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("RosinhaColor"))
                    
                    Image(systemName: "waveform")
                        .resizable()
                        .foregroundColor(Color("AccentColor"))
                        .frame(width: 25, height: 25)
                }
                //.padding()
                
                VStack(){
                    Text("Em espera")
                        .font(.title2.bold())
                    Text("Outra pessoas está gravando,\nespere o desafio estar livre\npara começar")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        
                }
                
                Spacer()
                Spacer()
                botaoGravacao()
            }
            .navigationTitle(Text("Encadeia"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancelar", systemImage: "xmark")
                    {
                        //dismis()
                    }
                }
                ToolbarItem(placement: .confirmationAction){
                    Button("confirmar", systemImage: "checkmark"){
                        
                    }
                    .tint(Color.gray)
                }
            }
        }
    }
}







#Preview {
    EaperaDesafioEncadeiaView()
}

