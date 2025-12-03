//
//  DesafiosList.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 25/11/25.
//

import SwiftUI

struct DesafiosList: View {
    @State private var criarDesafio = false
    @ObservedObject var resumoVM: ResumeViewModel
    let onNavigate: (ResumeCoordinatorView.Route) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(resumoVM.challenges) { desafio in
                    let groupName = resumoVM.challengeGroups[desafio] ?? "Grupo não encontrado"
                    
                    if(resumoVM.isTeacher){
                        if(desafio.endDate < Date()){
                            ListCard(title: desafio.title, subtitle: "Resultado", image: GrayChallengeImage())
                                .onTapGesture {
                                    resumoVM.members = []
                                    onNavigate(.detailChallenge(desafio))
                                }
                            
                        } else {
                            ListCard(title: desafio.title, subtitle: groupName, image: ChallengeImage())
                                .onTapGesture {
                                    resumoVM.members = []
                                    onNavigate(.detailChallenge(desafio))
                                }
                        }
                    } else {
                        let diasRestantes = Calendar.current.dateComponents([.day], from: Date(), to: desafio.endDate).day ?? 0
                        
                        if(desafio.endDate >= Date()){
                            ListCard(title: desafio.title, subtitle: "Faltam \(diasRestantes) dias!", image: ChallengeImage())
                                .onTapGesture {
                                    resumoVM.members = []
                                    onNavigate(.detailChallenge(desafio))
                                }
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
        .toolbar(){
            if(resumoVM.isTeacher){
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        criarDesafio = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color(.black))
                    }
                }
            }
        }
        .sheet(isPresented: $criarDesafio) {
            CriarDesafioView(numChallenge: .constant(0))
        }
    }
}


//#Preview {
//    DesafiosList()
//}
