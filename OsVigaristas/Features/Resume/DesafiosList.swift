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
                    HStack(spacing: 16) {
                        ZStack {
                            if desafio.endDate < Date(){
                                Circle()
                                    .fill(.gray)
                                    .frame(width: 45, height: 45)
                            } else {
                                Circle()
                                    .fill(Color("BlueCard"))
                                    .frame(width: 45, height: 45)
                            }
                            
                            Image(systemName: "flag.pattern.checkered.2.crossed")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.white)
                        }
                        
                        Text(desafio.title)
                            .font(.title3.bold())
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        if desafio.endDate < Date(){
                            Text("Resultado")
                                .font(.caption.italic())
                                .foregroundColor(.black)
                        } else {
                            let diasRestantes = Calendar.current.dateComponents([.day], from: Date(), to: desafio.endDate).day ?? 0
                            Text("Faltam \(diasRestantes) dias!")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }
                    .onTapGesture {
                        resumoVM.members = []
                        onNavigate(.detailChallenge(desafio))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.12), radius: 5, y: 3)
                    )
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
