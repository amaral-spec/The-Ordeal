//
//  SemResultadosView.swift
//  Dingo
//
//  Created by Gabriel Amaral on 10/12/25.
//

import SwiftUI

struct SemResultadosView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.magnifyingglass")
                .font(.system(size: 52))
                .foregroundColor(.gray.opacity(0.6))
            
            Text("Nenhum resultado encontrado")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

