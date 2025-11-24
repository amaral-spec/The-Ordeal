//
//  InicioDesafioEncadeiaView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI

struct InitialChainedChallengeView: View {
    var body: some View {
        NavigationStack{
            Spacer()
            VStack{//Escrita
                TopPageInstructionView(instruction: "Toque algo de sua escolha por 15 segundos")
                Spacer()
                PinkIconImageView()
                ImageMessageView(title: "Grave o seu audio", subtitle: "Faça milage")
                Spacer()
                Spacer()
                NavigationLink{
                    ReceivedAudioRecordChainedChallengeView()
                }label:{
                    RecordingButtonView(color: .accentColor)
                    
                }
            }
            .navigationTitle(Text("Encadeia"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancelar", systemImage: "xmark")
                    {
                        // dismiss()
                    }
                }
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
}

#Preview {
    InitialChainedChallengeView()
}

