//
//  DetalheGrupoView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 11/11/25.
//

import SwiftUI
import CloudKit

struct DetailGroupView: View {
    let grupo: GroupModel
    @State private var members: [UserModel] = []
    @State private var isLoadingMembers = false
    @State private var selectedMember: UserModel?
    @State private var eachAluno: Bool = false
    @State private var isCopied: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Text(grupo.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("\(members.count) participantes")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                if isLoadingMembers {
                    ProgressView("Carregando membros...")
                        .padding()
                } else {
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 10){
                            ForEach(members, id: \.id) { member in
                                Button {
                                    selectedMember = member
                                    eachAluno = true
                                } label: {
                                    VStack {
                                        if let image = member.profileImage {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 80, height: 80)
                                                .clipShape(Circle())
                                        } else {
                                            Image(systemName: "person.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 80, height: 80)
                                                .foregroundColor(.gray)
                                        }
                                        Text(member.name)
                                            .lineLimit(1)
                                            .frame(minWidth: 60)
                                            .font(.headline)
                                            .padding(8)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
//                    .frame(maxWidth: .infinity)
                }
                
                Button {
                    UIPasteboard.general.string = grupo.groupCode
                    isCopied = true
                } label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        Text("Código do grupo: \(grupo.groupCode)")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity/*350, maxHeight: 52*/)
                    .background(Color.accentColor)
                    .cornerRadius(50)
                }
//                .frame(maxWidth: .infinity, minHeight: 70)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.secondarySystemBackground))
        .navigationTitle("Detalhes do Grupo")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadMembers()
        }
        .sheet(isPresented: $eachAluno) {
            if let member = selectedMember {
                DetailEachAluno(member: member)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
        .overlay(alignment: .top) {
            if isCopied {
                Text("Código copiado com sucesso!")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color("BlueCard"))
                    .cornerRadius(30)
                    .padding(.top, 40)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(Animation.easeInOut(duration: 0.5), value: !isCopied)
            }
        }
    }
    
    @MainActor
    private func loadMembers() async {
        guard !isLoadingMembers else { return }
        isLoadingMembers = true
        defer { isLoadingMembers = false }
            
        do {
            let db = CKContainer.default().publicCloudDatabase
            var loadedMembers: [UserModel] = []
            for ref in grupo.members {
                let record = try await db.record(for: ref.recordID)
                let user = UserModel(from: record)
                loadedMembers.append(user)
            }
            members = loadedMembers
        } catch {
            print("Erro ao carregar membros do grupo: \(error)")
        }
    }
}

#Preview {
    DetailGroupView(grupo: GroupModel(name: "Exemplo de Grupo"))
}
