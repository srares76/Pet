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
    
    var body: some Scene {
        WindowGroup {
            MarkedAppsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        HotkeyManager.shared
    }
}
