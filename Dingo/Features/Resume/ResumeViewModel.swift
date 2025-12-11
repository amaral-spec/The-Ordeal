//
//  ProfessorDesafiosViewModel.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 14/11/25.
//

import Foundation
import CloudKit
import AVFoundation

final class ResumeViewModel: ObservableObject {
    @Published var challenges: [ChallengeModel] = []
    
    @Published var tasks: [TaskModel] = []
    
    @Published var members: [UserModel] = []
    @Published var challengeGroups: [ ChallengeModel : String ] = [:]
    @Published var alunosTarefas: [UserModel] = []
    
    @Published var audios: [any AudioRecordProtocol] = []
    
    @Published var isTeacher: Bool = false
    
    @Published var groupsByID: [CKRecord.ID : GroupModel] = [:]
    @Published private var isChallengeEmpty: Bool = true
    @Published private var isTaskEmpty: Bool = true
    @Published private var isMemberEmpty: Bool = true
    @Published private var isAudioEmpty: Bool = true
    @Published private var isAlunosTarefasEmpty: Bool = true
    
    let persistenceServices: PersistenceServices
    
    init(persistenceServices: PersistenceServices, isTeacher: Bool) {
        self.persistenceServices = persistenceServices
        self.isTeacher = isTeacher
    }
    
    func currentOpenTasks() -> [TaskModel] {
        if !isTeacher {
            tasks.filter { $0.endDate >= Date() }
        } else {
            tasks
        }
    }
    
    func currentOpenChallenges() -> [ChallengeModel] {
        if !isTeacher {
            challenges.filter { $0.endDate >= Date() }
        } else {
            challenges
        }
    }
    
    func carregarDesafios() async {
        var challengeGroupsDict: [ChallengeModel : String] = [:]
        
        do {
            // 1. Busca todos os desafios
            let desafiosCarregados = try await persistenceServices.fetchAllChallenges()
            
            // 2. Extrai apenas os IDs de grupo ÚNICOS (Remove duplicatas para não buscar o mesmo grupo 2 vezes)
            let uniqueGroupIDs = Set(desafiosCarregados.compactMap { $0.group?.recordID })
            
            // Dicionário temporário para guardar [ID do Grupo : Nome do Grupo]
            var groupNamesByID: [CKRecord.ID : String] = [:]
            
            // 3. Abre um Grupo de Tarefas para buscar os grupos em PARALELO
            try await withThrowingTaskGroup(of: (CKRecord.ID, String).self) { group in
                
                for groupID in uniqueGroupIDs {
                    group.addTask {
                        // Aqui a mágica acontece: Vários requests saem ao mesmo tempo
                        let groupModel = try await self.persistenceServices.fetchGroup(recordID: groupID)
                        return (groupID, groupModel.name)
                    }
                }
                
                // Coleta os resultados conforme eles chegam
                for try await (id, name) in group {
                    groupNamesByID[id] = name
                }
            }
            
            // 4. Monta o dicionário final cruzando os dados locais (memória, instantâneo)
            for desafio in desafiosCarregados {
                if let groupID = desafio.group?.recordID, let groupName = groupNamesByID[groupID] {
                    challengeGroupsDict[desafio] = groupName
                }
            }
            
            // 5. Atualiza a UI
            await MainActor.run {
                challengeGroups = challengeGroupsDict
                challenges = desafiosCarregados
                isChallengeEmpty = desafiosCarregados.isEmpty
            }
            
            print("\(desafiosCarregados.count) desafios carregados e processados.")
            
        } catch {
            print("Erro ao carregar desafios: \(error.localizedDescription)")
        }
    }
    
    func carregarGrupo(reference: CKRecord.Reference) async throws -> GroupModel{
        let grupo = try await persistenceServices.fetchGroup(recordID: reference.recordID)
        return grupo
    }
    
    func carregarTarefas() async {
        do {
            let tarefasCarregadas = try await persistenceServices.fetchAllTasks()
            await MainActor.run {
                tasks = tarefasCarregadas
                isTaskEmpty = tarefasCarregadas.isEmpty
            }
            print("\(tarefasCarregadas.count) tarefas carregadas")
        } catch {
            print("Erro ao carregar tarefas: \(error.localizedDescription)")
        }
    }
    
    func carregarParticipantesPorDesafio(challenge: ChallengeModel) async {
        do {
            let participantesCarregados = try await persistenceServices.fetchChallengeMembers(recordReference: challenge.group!)
            await MainActor.run {
                members = participantesCarregados
                isMemberEmpty = participantesCarregados.isEmpty
            }
            print("\(participantesCarregados.count) participantes carregados")
        } catch {
            print("Erro ao carregar participantes: \(error.localizedDescription)")
        }
    }
    
    func carregarParticipantesPorTarefa(task: TaskModel) async {
        let taskRef = CKRecord.Reference(recordID: task.id, action: .none)
        
        do {
            let participantesCarregados = try await persistenceServices.fetchTaskMembers(recordReference: taskRef)
            await MainActor.run {
                members = participantesCarregados
                isMemberEmpty = participantesCarregados.isEmpty
            }
            print("\(participantesCarregados.count) participantes carregados")
        } catch {
            print("Erro ao carregar participantes: \(error.localizedDescription)")
        }
    }
    
    func formatarDiaMes(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter.string(from: date)
    }
    
    func diasRestantes(ate endDate: Date) -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let end = calendar.startOfDay(for: endDate)
        return calendar.dateComponents([.day], from: start, to: end).day ?? 0
    }
    
    func carregarAudios(challengeID: CKRecord.ID) async {
        do {
            let audiosCarregados: [AudioRecordChallengeModel] =
            try await persistenceServices.fetchChallengeAudio(challengeID: challengeID)
            
            await MainActor.run {
                self.audios = audiosCarregados.sorted(by: { $0.createdAt < $1.createdAt }) as [any AudioRecordProtocol]
            }
        } catch {
            print("Erro ao carregar audios: \(error)")
        }
    }
    
    func carregarAudios(taskID: CKRecord.ID) async {
        do {
            let audiosCarregados: [AudioRecordTaskModel] =
            try await persistenceServices.fetchTaskAudio(taskID: taskID)
            
            await MainActor.run {
                self.audios = audiosCarregados as [any AudioRecordProtocol]
            }
        } catch {
            print("Erro ao carregar audios: \(error)")
        }
    }
    
    
    func carregarAlunosTarefa(task: TaskModel) async {
        do {
            let taskRef = CKRecord.Reference(recordID: task.id, action: .none)
            
            let alunosTarefaCarregados = try await persistenceServices.fetchTaskMembers(recordReference: taskRef)
            await MainActor.run {
                alunosTarefas = alunosTarefaCarregados
                isAlunosTarefasEmpty = alunosTarefaCarregados.isEmpty
            }
            print("\(alunosTarefaCarregados.count) alunos carregados.")
        } catch {
            print("Erro ao carregar participantes: \(error.localizedDescription)")
        }
    }
    
}

extension ResumeViewModel {
    func audioFor(member: UserModel) -> (any AudioRecordProtocol)? {
        audios.first { audio in
            audio.userRef.recordID == member.id
        }
    }
    
}

// MARK: - Extension Audio Merge
extension ResumeViewModel {
    
    func mergeAudioFiles() async throws -> URL {
        let composition = AVMutableComposition()
        let fileManager = FileManager.default
        
        guard let compositionAudioTrack = composition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: Int32(kCMPersistentTrackID_Invalid)
        ) else {
            throw NSError(domain: "AudioMerge", code: -1, userInfo: [NSLocalizedDescriptionKey: "Falha ao criar track."])
        }

        var currentTime = CMTime.zero
        var hasAddedAudio = false

        // Pasta temporária segura para manipularmos os arquivos
        let tempDir = fileManager.temporaryDirectory

        print("🔍 Iniciando processamento de \(audios.count) áudios...")

        for (index, audioRecord) in audios.enumerated() {
            let sourceURL = audioRecord.audioURL
            
            // 1. VERIFICAÇÃO DE EXISTÊNCIA FÍSICA
            // O path deve ser retirado da URL com .path (ou .path(percentEncoded: false) em iOS 16+)
            guard fileManager.fileExists(atPath: sourceURL.path) else {
                print("❌ [Áudio \(index)] Arquivo não encontrado no disco: \(sourceURL.path)")
                print("   -> Sugestão: O CKAsset pode não ter sido baixado ou a URL expirou.")
                continue
            }
            
            // 2. CÓPIA DE SEGURANÇA (Resolve problemas de permissão do CloudKit)
            // Criamos uma cópia local para garantir que o AVAsset consiga ler sem restrições
            let safeTempURL = tempDir.appendingPathComponent("temp_track_\(index)_\(UUID().uuidString).m4a")
            
            do {
                try fileManager.copyItem(at: sourceURL, to: safeTempURL)
            } catch {
                print("⚠️ [Áudio \(index)] Falha ao copiar para temp: \(error.localizedDescription)")
                continue
            }
            
            // 3. CARREGAMENTO (Usando a cópia segura)
            let asset = AVURLAsset(url: safeTempURL)
            
            do {
                let tracks = try await asset.load(.tracks)
                let duration = try await asset.load(.duration)
                
                if let trackToInsert = tracks.first(where: { $0.mediaType == .audio }), duration.seconds > 0 {
                    let timeRange = CMTimeRange(start: .zero, duration: duration)
                    try compositionAudioTrack.insertTimeRange(timeRange, of: trackToInsert, at: currentTime)
                    
                    currentTime = CMTimeAdd(currentTime, duration)
                    hasAddedAudio = true
                    print("✅ [Áudio \(index)] Adicionado com sucesso. Duração: \(String(format: "%.2f", duration.seconds))s")
                } else {
                    print("⚠️ [Áudio \(index)] Arquivo existe mas não possui trilha de áudio legível.")
                }
                
                // Limpeza da cópia temporária individual (opcional, mas boa prática)
                try? fileManager.removeItem(at: safeTempURL)
                
            } catch {
                print("❌ [Áudio \(index)] Erro ao processar asset: \(error.localizedDescription)")
            }
        }

        // 4. VERIFICAÇÃO FINAL
        guard hasAddedAudio, composition.duration.seconds > 0 else {
            throw NSError(domain: "AudioMerge", code: -11838, userInfo: [NSLocalizedDescriptionKey: "Nenhum áudio válido processado. Verifique se os arquivos do CloudKit foram baixados corretamente."])
        }

        // 5. EXPORTAÇÃO
        let exportFileName = "mergedFinal-\(UUID().uuidString).m4a"
        let outputURL = tempDir.appendingPathComponent(exportFileName)

        if fileManager.fileExists(atPath: outputURL.path) {
            try? fileManager.removeItem(at: outputURL)
        }

        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) else {
            throw NSError(domain: "AudioMerge", code: -2, userInfo: [NSLocalizedDescriptionKey: "Erro ao criar sessão."])
        }
        
        exportSession.outputFileType = .m4a
        exportSession.outputURL = outputURL
        
        await exportSession.export()

        switch exportSession.status {
        case .completed:
            print("🎉 Áudio unificado gerado em: \(outputURL)")
            return outputURL
        case .failed:
            throw exportSession.error ?? NSError(domain: "AudioMerge", code: -3, userInfo: [NSLocalizedDescriptionKey: "Falha na exportação final."])
        default:
            throw NSError(domain: "AudioMerge", code: -4, userInfo: [NSLocalizedDescriptionKey: "Exportação cancelada."])
        }
    }
}
