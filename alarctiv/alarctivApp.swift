//
//  alarctivApp.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

/// alarctive is an alarm app built with swift ui for making sure you wake up forcefully

import SwiftUI

@main
struct alarctivApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(.blue)
                #if os(macOS)
                .frame(minWidth: 440, idealWidth: 500, maxWidth: 640, minHeight: 640, idealHeight: 740)
                #endif
        }
    }
}
