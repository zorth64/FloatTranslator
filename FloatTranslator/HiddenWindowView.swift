//
//  HiddenWindowView.swift
//  Float Translator
//
//  Created by zorth64 on 06/03/26.
//

import SwiftUI

struct HiddenWindowView: View {
    @Environment(\.openSettings) private var openSettings
    
    var body: some View {
        Color.clear
            .frame(width: 1, height: 1)
            .onReceive(NotificationCenter.default.publisher(for: .openSettingsRequest)) { _ in
                Task { @MainActor in
                    NSApp.setActivationPolicy(.regular)
                    
                    try? await Task.sleep(for: .milliseconds(100))
                    
                    NSApp.activate(ignoringOtherApps: true)
                    openSettings()
                    
                    try? await Task.sleep(for: .milliseconds(200))
                    
                    if let settingsWindow = HiddenWindowView.findSettingsWindow() {
                        settingsWindow.makeKeyAndOrderFront(nil)
                        settingsWindow.orderFrontRegardless()
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .settingsWindowClosed)) { _ in
                NSApp.setActivationPolicy(.accessory)
            }
    }
    
    static let settingsWindowIdentifier: String = "com.apple.SwiftUI.Settings"

    static func findSettingsWindow() -> NSWindow? {
        return NSApp.windows.first { window in
            if (window.identifier?.rawValue == settingsWindowIdentifier) {
                return true
            }
            
            if (window.isVisible && window.styleMask.contains(.titled) && (window.title.localizedCaseInsensitiveContains("settings") || window.title.localizedCaseInsensitiveContains("preferences"))) {
                return true
            }
            
            if let contentViewController = window.contentViewController,
               String(describing: type(of: contentViewController)).contains("Settings") {
                return true
            }
            
            return false
        }
    }
}

extension Notification.Name {
    static let openSettingsRequest = Notification.Name("openSettingsRequest")
    static let settingsWindowClosed = Notification.Name("settingsWindowClosed")
}
