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

    private init() {
        registerHotkey()
    }

    private func registerHotkey() {
        var gMyHotKeyID = EventHotKeyID(signature: OSType(32), id: UInt32(1))
        var eventHotKeyRef: EventHotKeyRef?
        let modifierFlags: UInt32 = UInt32(controlKey) // Command key
        let keyCode: UInt32 = UInt32(kVK_ANSI_A) // 'A' key

        // Register the hotkey
        let status = RegisterEventHotKey(keyCode, modifierFlags, gMyHotKeyID, GetApplicationEventTarget(), 0, &eventHotKeyRef)
        if status != noErr {
            print("Error registering hotkey: \(status)")
        }

        // Install the event handler
        InstallEventHandler(GetApplicationEventTarget(), {
            (nextHandler, theEvent, userData) -> OSStatus in
            var hotKeyID = EventHotKeyID()
            GetEventParameter(theEvent, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hotKeyID)

            switch hotKeyID.id {
            case 1:
                HotkeyManager.shared.handleHotkey()
                return noErr
            default:
                return noErr
            }
        }, 1, [EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: OSType(kEventHotKeyPressed))], nil, nil)
    }

    private func handleHotkey() {
        if let frontmostApp = NSWorkspace.shared.frontmostApplication {
            print("Current frontmost app: \(frontmostApp.localizedName ?? "Unknown")")
        } else {
            print("Could not determine the frontmost app")
        }
    }
}
