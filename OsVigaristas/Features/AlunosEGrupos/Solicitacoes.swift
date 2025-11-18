//
//  Solicitacoes.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 18/11/25.
//

import SwiftUI
import CloudKit

struct Solicitacoes: View {
    @EnvironmentObject var persistenceServices: PersistenceServices
    @State private var solicitacoes: [CKRecord.ID : [UserModel]] = [:]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                List {
                    
                }
            }
            .navigationTitle("Solicitações")
            .task {
                do {
                    solicitacoes = try await persistenceServices.fetchSolicitations()
                } catch {
                    print("Solicitações não carregadas: \(error)")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

