//
//  AppState.swift
//  Pet
//
//  Created by Stefan Rares on 08.07.2024.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var runningApps: [RunningApp] = []

    func addRunningApp(_ app: RunningApp) {
        runningApps.append(app)
    }
}
