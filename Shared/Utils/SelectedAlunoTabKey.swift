//
//  SelectedAlunoTabKey.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 14/11/25.
//


import SwiftUI

struct SelectedStudentTabKey: EnvironmentKey {
    static let defaultValue: Binding<studentTabs>? = nil
}

extension EnvironmentValues {
    var selectedStudentTab: Binding<studentTabs>? {
        get { self[SelectedStudentTabKey.self] }
        set { self[SelectedStudentTabKey.self] = newValue }
    }
}
