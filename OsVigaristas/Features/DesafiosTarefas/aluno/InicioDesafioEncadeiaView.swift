//
//  InicioDesafioEncadeiaView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI

struct InicioDesafioEncadeiaView: View {
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
                
                VStack{
                    Text("Grave o seu audio")
                        .font(.title2.bold())
                    Text("Faça milage")
                        .font(.title3)
                        .foregroundColor(.gray)
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
                    .tint(Color("AccentColor"))
                }
            }
        }
    }
}




struct botaoGravacao: View{
    var color: Color
    var body: some View{
        
        ZStack(alignment: .center){
            
            Circle()
                .frame(width: 63, height: 63)
                .foregroundColor(.accentColor)
         
            Image("custom.waveform.badge.record")
                .resizable()
                .foregroundColor(.white)
                .padding(.trailing, 1)
                .frame(width: 50, height: 45)
                .padding()
        }
    }
}


#Preview {
    InicioDesafioEncadeiaView()
}

