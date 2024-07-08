//
//  MarkedAppsView.swift
//  Pet
//
//  Created by Stefan Rares on 08.07.2024.
//

import SwiftUI

struct MarkedAppsView: View {
    @State private var runningApps: [RunningApp] = []
    var body: some View {
        List(runningApps) { app in
            HStack {
                Image(nsImage: app.icon)
                    .resizable()
                    .frame(width: 32, height: 32)
                Text(app.name)
                    .font(.headline)
            }
        }
        .onAppear{
            self.runningApps = RunningApp.getAllRunningApps()
        }
    }
}

#Preview {
    MarkedAppsView()
}
