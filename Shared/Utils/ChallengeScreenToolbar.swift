//
//  ChallengeScreenToolbar.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 24/11/25.
//

import SwiftUI

protocol ChallengeScreenToolbar {
    associatedtype Toolbar: ToolbarContent
    @ToolbarContentBuilder static var toolbarItems: Toolbar { get }
}
