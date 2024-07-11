//
//  HotkeyManager.swift
//  Pet
//
//  Created by Stefan Rares on 08.07.2024.
//

import Cocoa
import Carbon

class HotkeyManager {
    static let shared = HotkeyManager()
    var markedAppsList: MarkedAppsList?

    private init() {
        registerHotkeys()
    }

    func setMarkedAppsList(_ list: MarkedAppsList) {
        self.markedAppsList = list
    }

    private func registerHotkeys() {
        registerHotkey(keyCode: UInt32(kVK_ANSI_A), modifierFlags: UInt32(controlKey), hotKeyID: EventHotKeyID(signature: OSType(32), id: UInt32(1)))
        registerHotkey(keyCode: UInt32(kVK_ANSI_Q), modifierFlags: UInt32(cmdKey), hotKeyID: EventHotKeyID(signature: OSType(33), id: UInt32(2)))
        registerHotkey(keyCode: UInt32(kVK_ANSI_S), modifierFlags: UInt32(controlKey), hotKeyID: EventHotKeyID(signature: OSType(34), id: UInt32(3)))
        registerHotkey(keyCode: UInt32(kVK_ANSI_1), modifierFlags: UInt32(controlKey), hotKeyID: EventHotKeyID(signature: OSType(35), id: UInt32(4)))
        registerHotkey(keyCode: UInt32(kVK_ANSI_2), modifierFlags: UInt32(controlKey), hotKeyID: EventHotKeyID(signature: OSType(36), id: UInt32(5)))
        registerHotkey(keyCode: UInt32(kVK_ANSI_3), modifierFlags: UInt32(controlKey), hotKeyID: EventHotKeyID(signature: OSType(37), id: UInt32(6)))
        registerHotkey(keyCode: UInt32(kVK_ANSI_4), modifierFlags: UInt32(controlKey), hotKeyID: EventHotKeyID(signature: OSType(38), id: UInt32(7)))
        registerHotkey(keyCode: UInt32(kVK_ANSI_5), modifierFlags: UInt32(controlKey), hotKeyID: EventHotKeyID(signature: OSType(39), id: UInt32(8)))
    }

    private func registerHotkey(keyCode: UInt32, modifierFlags: UInt32, hotKeyID: EventHotKeyID) {
        var eventHotKeyRef: EventHotKeyRef?
        let status = RegisterEventHotKey(keyCode, modifierFlags, hotKeyID, GetApplicationEventTarget(), 0, &eventHotKeyRef)
        if status != noErr {
            print("Error registering hotkey: \(status)")
        }

        InstallEventHandler(GetApplicationEventTarget(), {
            (nextHandler, theEvent, userData) -> OSStatus in
            var hotKeyID = EventHotKeyID()
            GetEventParameter(theEvent, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hotKeyID)

            switch hotKeyID.id {
            case 1:
                HotkeyManager.shared.handleHotkey()
                return noErr
            case 2:
                HotkeyManager.shared.handleCommandQ()
                return noErr
            case 3:
                HotkeyManager.shared.handleControlS()
                return noErr
            case 4...8:
                HotkeyManager.shared.handleControlDigit(Int(hotKeyID.id) - 4)
                return noErr
            default:
                return noErr
            }
        }, 1, [EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: OSType(kEventHotKeyPressed))], nil, nil)
    }

    private func handleHotkey() {
        if let frontmostApp = NSWorkspace.shared.frontmostApplication {
            let appName = frontmostApp.localizedName ?? "Unknown"
            let appIcon = frontmostApp.icon ?? NSImage()
            let appToAdd = RunningApp(name: appName, icon: appIcon)

            DispatchQueue.main.async {
                if let index = self.markedAppsList?.apps.firstIndex(of: appToAdd) {
                    self.markedAppsList?.apps.remove(at: index)
                } else {
                    if self.markedAppsList?.apps.count ?? 0 >= 5 {
                        self.markedAppsList?.apps.removeFirst()
                    }
                    self.markedAppsList?.apps.append(appToAdd)
                }
            }
        } else {
            print("Could not determine the frontmost app")
        }
    }

    private func handleCommandQ() {
        NSApp.hide(nil)
    }

    private func handleControlS() {
        NSApp.unhide(nil)
        NSApp.activate(ignoringOtherApps: true)
        if let window = NSApp.windows.first {
            window.makeKeyAndOrderFront(nil)
        }
    }

    private func handleControlDigit(_ index: Int) {
        guard let markedAppsList = markedAppsList else { return }

        // Save the currently active application
        let originalApp = NSWorkspace.shared.frontmostApplication

        // Bring the Pet app to the foreground
        NSApp.activate(ignoringOtherApps: true)

        // Attempt to bring the selected app to the foreground
        var appBroughtToFront = false
        if index < markedAppsList.apps.count, let app = markedAppsList.apps[safe: index] {
            if let runningApp = NSWorkspace.shared.runningApplications.first(where: { $0.localizedName == app.name }) {
                runningApp.unhide()
                appBroughtToFront = runningApp.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
            }
        }

        // If no app was brought to the foreground, restore the original app
        if !appBroughtToFront, let originalApp = originalApp {
            originalApp.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
        }
    }
}

// Safe index access
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
