//
//  EmptyStateView.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 14/11/25.
//

import SwiftUI
import Foundation

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack{
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.3))
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(Color.accentColor)
            }

            Text(title)
                .font(.title3)
                .fontWeight(.bold)

            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
}
