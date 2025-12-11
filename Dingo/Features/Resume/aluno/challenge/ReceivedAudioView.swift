//
//  ReceivedAudioRecordChainedChallengeView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI
import Combine
import AVFoundation

struct ReceivedAudioView: View {
    
    // MARK: - Environment & State
    @EnvironmentObject var doChallengeVM: DoChallengeViewModel
    @EnvironmentObject var player: MiniPlayer
    @EnvironmentObject var rec: MiniRecorder
    
    @State private var urlShowed: URL? = nil
    private var title: String { doChallengeVM.challengeM?.whichChallenge == 1 ? "Ecco" : "Encadeia" }
    private var instruction: String { doChallengeVM.challengeM?.whichChallenge == 1 ? "Tente gravar o audio completo" : "Grave uma continuação para o audio abaixo" }
    
    // MARK: - Callbacks
    let onNavigation: (DoChallengeCoordinatorView.Route) -> Void
    
    // MARK: - Body
    var body: some View {
        VStack {
            
            // 1. Instruções
            TopPageInstructionView(instruction: instruction)
            
            Spacer()
            
            // 2. Player de Áudio
            HStack{
                VStack(alignment: .leading) {
                    Text("Áudio Original")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    
                    audioPlayerSection
                        .padding(32)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.secondarySystemBackground))
                                .padding(16)
                        )
                        .frame(width: 350)
                }
                Spacer()
            }
            
            Spacer()
            
            // 4. Visualizador de Gravação
            HStack{
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Sua Gravação")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    
                    MultiBarVisualizerView(values: rec.meterHistory, barCount: 24)
                        .frame(height: 40)
                        .padding(32)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.secondarySystemBackground))
                                .padding(16)
                        )
                        .frame(width: 310, height: 110)
                        
                }
                
            }
            
            Spacer()
            
            // 5. Botão de Gravar
            recordButton
            
        }
        .task {
            if doChallengeVM.challengeM?.whichChallenge == 1,
               let url = await doChallengeVM.getLastAudioToBeCompleted() {
                urlShowed = url
            } else if let url = await doChallengeVM.getAudioToBeCopied() {
                urlShowed = url
            }
        }
        .navigationTitle(Text(title))
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Componentes da View
extension ReceivedAudioView {
    
    private var audioPlayerSection: some View {
        HStack {
            Button {
                handlePlayTap()
            } label: {
                Image(systemName: isPlayingCurrentUrl ? "pause.fill" : "play.fill")
            }
            .buttonStyle(.plain)
            .disabled(urlShowed == nil)
            
            PlaybackWaveformView(progress: player.progress)
        }
    }
    
    private var recordButton: some View {
        Button {
            toggleRecording()
        } label: {
            RecordingButtonView(isRecording: rec.isRecording)
        }
    }
}

// MARK: - Lógica Auxiliar
extension ReceivedAudioView {
    
    private var isPlayingCurrentUrl: Bool {
        player.playingURL == urlShowed && player.isPlaying
    }
    
    private func toggleRecording() {
        if rec.isRecording {
            rec.stop()
            onNavigation(.recordReceived)
        } else {
            rec.start()
        }
    }
    
    private func handlePlayTap() {
        guard let url = urlShowed else { return }
        
        // Se já estiver tocando esse áudio, apenas pausa
        if isPlayingCurrentUrl {
            player.pause()
            return
        }
        
        // Lógica dos últimos 5 segundos
        if doChallengeVM.challengeM?.whichChallenge == 1 {
            playLastFiveSeconds(of: url)
        } else {
            // Toca normalmente do início
            player.play(url)
        }
    }
    
    private func playLastFiveSeconds(of url: URL) {
        Task {
            let asset = AVURLAsset(url: url)
            
            do {
                // Carrega a duração de forma assíncrona (seguro para iOS 15+)
                let duration = try await asset.load(.duration).seconds
                
                // Calcula o tempo de início (Duração total - 5s, mas não menor que 0)
                let startTime = max(0, duration - 5.0)
                
                // EXECUÇÃO NO PLAYER
                // Tenta buscar o tempo no Player.
                // Se o seu player não suportar 'startTime' no play, veja a nota abaixo.
                await MainActor.run {
                    player.play(url)
                    player.seek(to: startTime)
                }
                
            } catch {
                print("Erro ao calcular duração: \(error)")
                // Fallback: toca do inicio se der erro
                player.play(url)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ReceivedAudioView(onNavigation: { _ in
        print("Navegue")
    })
    // Injeção de dependências mockadas seria necessária aqui para o preview funcionar 100%
}
