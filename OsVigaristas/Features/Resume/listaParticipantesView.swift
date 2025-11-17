//
//  listaParticipantesView.swift
//  OsVigaristas
//
//  Created by Jordana Lourenço Santos on 17/11/25.
//

import SwiftUI

struct listaParticipantesView: View {
    @StateObject var resumeVM: ResumeViewModel
    
    var body: some View {
        NavigationStack{
            ScrollView(){
                VStack(alignment: .leading){
                    ForEach (0..<5) {_ in
                        Participante()
                        
                        if(resumeVM.isTeacher){
                            Image("audio")
                                .resizable()
                                .frame(width: 380, height: 90)
                                .padding(.horizontal)
                            //coloca aqui o audio de vdd
                        }
                        Divider()
                    }
                    .padding(5)
                }
                
            }
            .navigationTitle("Participantes")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

//MARK: PARTICIPANTE

struct Participante: View {
    
    var body: some View {
        HStack{
            Image("partitura")
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(.horizontal)
            
            Text("Jordana Santos")
            Spacer()
        }
    }
}

#Preview {
    listaParticipantesView(resumeVM: ResumeViewModel(isTeacher: true))
}
