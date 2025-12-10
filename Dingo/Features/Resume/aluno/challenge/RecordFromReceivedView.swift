//
//  RecordFromReceivedView.swift
//  AudioRecorderDemo2
//
//  Created by João Victor Perosso Souza on 12/11/25.
//

import SwiftUI
import Combine
import AVFoundation

struct RecordFromReceivedView: View {

    // MARK: - Environment & State
    @EnvironmentObject var doChallengeVM: DoChallengeViewModel
    @EnvironmentObject var player: MiniPlayer
    
    // URL do áudio original (o prompt/pergunta)
    @State private var originalPromptURL: URL? = nil
    
    // URL da gravação do usuário (resposta)
    private var userRecordingURL: URL? {
        doChallengeVM.recordings.first
    }
    
    // Callbacks
    let onNavigation: (DoChallengeCoordinatorView.Route) -> Void

    // Computed Properties para UI
    private var title: String {
        doChallengeVM.challengeM?.whichChallenge == 1 ? "Ecco" : "Encadeia"
    }
    
    private var instruction: String {
        doChallengeVM.challengeM?.whichChallenge == 1
            ? "Tente gravar o audio completo"
            : "Grave uma continuação para o audio abaixo"
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            
            TopPageInstructionView(instruction: instruction)

            Spacer()
            
            // 1. Player do Áudio Original (se existir)
            if let promptURL = originalPromptURL {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Áudio Original")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    
                    audioPlayerRow(for: promptURL)
                }
            }
            
            // 2. Player da Gravação do Usuário
            if let recordingURL = userRecordingURL {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sua Gravação")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    
                    audioPlayerRow(for: recordingURL)
                }
            } else {
                // Caso algo tenha dado errado e não tenha gravação
                Text("Nenhuma gravação encontrada")
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // 3. Botão de Regravar
            Button {
                onNavigation(.receive)
            } label: {
                Text("Regravar Audio")
                    .foregroundStyle(.white)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("BlueCard"))
        }
        .padding(.vertical)
        .task {
            // Carrega as gravações e o áudio original
            doChallengeVM.recordings = doChallengeVM.recordingsList()
            if let url = await doChallengeVM.getLastAudioToBeCompleted() {
                originalPromptURL = url
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Componentes Reutilizáveis
extension RecordFromReceivedView {
    
    /// Cria uma linha de player para um URL específico
    @ViewBuilder
    private func audioPlayerRow(for url: URL) -> some View {
        HStack {
            Button {
                togglePlay(for: url)
            } label: {
                Image(systemName: isPlaying(url) ? "pause.fill" : "play.fill")
                    .font(.title2)
            }
            .buttonStyle(.plain)
            
            // Só passa o progresso se este for o áudio tocando atualmente.
            // Caso contrário, mostra 0 (ou mantém estático).
            PlaybackWaveformView(progress: isPlaying(url) ? player.progress : 0)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .padding(.horizontal, 16)
        )
    }
}

// MARK: - Lógica do Player
extension RecordFromReceivedView {
    
    /// Verifica se o URL fornecido é o que está tocando no momento
    private func isPlaying(_ url: URL) -> Bool {
        return player.playingURL == url && player.isPlaying
    }
    
    /// Gerencia o Play/Pause para o URL fornecido
    private func togglePlay(for url: URL) {
        if isPlaying(url) {
            player.pause()
        } else {
            // O Player deve lidar internamente com parar o áudio anterior
            // quando um novo play é solicitado.
            player.play(url)
        }
    }
}
