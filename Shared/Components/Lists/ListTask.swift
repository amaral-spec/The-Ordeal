//
//  ListaTarefas.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 14/11/25.
//

import SwiftUI
import Foundation

struct ListTask: View {
    let taskList: [TaskModel]
    let onTap: (TaskModel) -> Void

    var body: some View {
        ScrollView {
            ForEach(taskList) { task in
                Button {
                    onTap(task)
                } label: {
                    Card(name: task.title, quantity: 10)
                }
                .buttonStyle(.plain)

                Spacer(minLength: 20)
            }
        }
    }
}
