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
        NavigationStack{
            
            Spacer()
            VStack{//Escrita
                Text("Toque algo de sua escolha por 15 segundos")
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title3.bold())
                Spacer()
                
                Spacer()
          
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width:.infinity, height: 80)
                        .padding()
                        .foregroundColor(Color(red: 243/255, green: 242/255, blue: 248/255))
                        //.shadow(radius: 10)//Tirar
                    
                    HStack{
                        Button{
                            
                        }label: {
                           
                            Image(systemName: "play.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color(.black))
                            
                        }
                        .padding()
                        
                        Spacer()
                        
                    }.frame(width:.infinity, height: 80)
                    .padding()
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




#Preview {
    GravarDesafioEncadeiaView()
}

