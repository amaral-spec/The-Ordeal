//
//  CardView.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 12/11/25.
//

import SwiftUI

struct Card: View {
    let index: Int
    
    var body: some View {
        ZStack {
            Image("violao")
                .resizable()
        }
        .frame(width: 370, height: 190)
        .cornerRadius(30)
    }
}

//#Preview {
//    CardView()
//}
