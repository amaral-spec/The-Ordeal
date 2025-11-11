//
//  Usuarios.swift
//  OsVigaristas
//
//  Created by Assistant on 11/11/25.
//

import Foundation
import SwiftData

@Model
final class Usuarios {
    // Persisted properties
    @Attribute(.unique) var id: String
    var nome: String?
    var email: String?
    var isProfessor: Bool
    var hasCompletedOnboarding: Bool

    // Designated initializer
    init(id: String, nome: String? = nil, email: String? = nil, isProfessor: Bool = false, hasCompletedOnboarding: Bool = false) {
        self.id = id
        self.nome = nome
        self.email = email
        self.isProfessor = isProfessor
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
}
