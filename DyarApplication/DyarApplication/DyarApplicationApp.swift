//
//  DyarApplicationApp.swift
//  DyarApplication
//
//  Created by Wiam Ahmed Baalahtar on 08/07/1447 AH.
//

import SwiftUI
import SwiftData

@main
struct DyarApplicationApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
