//
//  DesafiosList.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 25/11/25.
//

import SwiftUI

struct DesafiosList: View {
    
    @ObservedObject var resumoVM: ResumeViewModel
    let onNavigate: (ResumeCoordinatorView.Route) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(resumoVM.challenges) { desafio in
                    
                    if(resumoVM.isTeacher){
                        if(desafio.endDate < Date()){
                            ListCard(title: desafio.title, subtitle: "Resultado", image: GrayChallengeImage())
                                .onTapGesture {
                                    onNavigate(.detailChallenge(desafio))
                                }
                            
                        } else{
                            ListCard(title: desafio.title, subtitle: "nome do grupo", image: ChallengeImage())
                                .onTapGesture {
                                    onNavigate(.detailChallenge(desafio))
                                }
                        }
                    } else {
                        let diasRestantes = Calendar.current.dateComponents([.day], from: Date(), to: desafio.endDate).day ?? 0
                        
                        if(desafio.endDate >= Date()){
                            ListCard(title: desafio.title, subtitle: "Faltam \(diasRestantes) dias!", image: ChallengeImage())
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .navigationTitle("Desafios")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await resumoVM.carregarDesafios()
        }
    }
}


//#Preview {
//    DesafiosList()
//}
