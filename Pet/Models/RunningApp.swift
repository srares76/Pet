//
//  RunningApp.swift
//  Pet
//
//  Created by Stefan Rares on 08.07.2024.
//

import Foundation
import AppKit

class RunningApp: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var icon: NSImage
    
    init(id: UUID = UUID(), name: String, icon: NSImage) {
        self.id = id
        self.name = name
        self.icon = icon
    }
    
    static func ==(lhs: RunningApp, rhs: RunningApp) -> Bool {
        return lhs.name == rhs.name
    }
    
    public static func getAllRunningApps() -> [RunningApp] {
        let runningApps = NSWorkspace.shared.runningApplications
            return runningApps.compactMap { app in
                guard let name = app.localizedName, let icon = app.icon else {
                    return nil
                }
                return RunningApp(name: name, icon: icon)
            }
    }
}
