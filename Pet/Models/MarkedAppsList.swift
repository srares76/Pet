//
//  MarkedAppsList.swift
//  Pet
//
//  Created by Stefan Rares on 11.07.2024.
//

import SwiftUI

final class MarkedAppsList: ObservableObject {
    @Published var apps: [RunningApp] = []
}
