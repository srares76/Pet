//
//  PetApp.swift
//  Pet
//
//  Created by Stefan Rares on 30.06.2024.
//

import SwiftUI
import SwiftData

@main
struct PetApp: App {
    var markedAppsList = MarkedAppsList()
    
    var body: some Scene {
        WindowGroup {
            MarkedAppsView()
                .onAppear {
                    HotkeyManager.shared.setMarkedAppsList(markedAppsList)
                }
                .environmentObject(markedAppsList)
        }
    }
}
