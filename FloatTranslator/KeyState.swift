//
//  KeyState.swift
//  Float Translator
//
//  Created by zorth64 on 06/03/26.
//

import SwiftUI
import KeyboardShortcuts

@MainActor
final class KeyState: ObservableObject {
    @Inject private var appState: AppState
    
    init() {
        KeyboardShortcuts.onKeyUp(for: .toggleWindow) { [weak self] in
            self?.toggleWindow()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleWindow), name: NSNotification.Name("toggleWindow"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("toggleWindow"), object: nil)
    }
    
    @objc func toggleWindow() {
        self.appState.toggleWindow()
    }
}
