//
//  PetApp.swift
//  Pet
//
//  Created by Stefan Rares on 30.06.2024.
//

import SwiftUI

@main
struct PetApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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

class AppDelegate: NSObject, NSApplicationDelegate {
    @EnvironmentObject var markedAppsList: MarkedAppsList
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        HotkeyManager.shared
    }
}
