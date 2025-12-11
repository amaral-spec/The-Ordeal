//
//  InicioDesafioEncadeiaView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI

struct InitialTaskView: View {
    
    @EnvironmentObject var doTaskVM: DoTaskViewModel
    @EnvironmentObject var rec: MiniRecorder
    let onNavigation: (DoTaskCoordinatorView.Route) -> Void
    
    var body: some View {
        VStack{//Escrita
            TopPageInstructionView(instruction: doTaskVM.taskM?.description ?? " Sem titulo para tarefa")
            Spacer()
            IconImageView(
                nomeIcone: "waveform",
                colorBackground: Color("GreenCard").opacity(0.3),
                colorText: Color("GreenCard")
            )
            ImageMessageView(title: "Grave o seu audio", subtitle: "")
            MultiBarVisualizerView(values: rec.meterHistory, barCount: 24)
                .frame(height: 54)
                .padding(.horizontal)
            Spacer()
            Spacer()
            Button {
                if rec.isRecording {
                    rec.stop()
                    onNavigation(.recordTask)
                } else {
                    rec.start()
                }
            } label: {
                RecordingButtonView(isRecording: rec.isRecording, color: Color("GreenCard"))
            }
        }
        .navigationTitle(Text(doTaskVM.taskM?.title ?? "Sem titulo"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
