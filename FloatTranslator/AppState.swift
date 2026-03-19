//
//  AppState.swift
//  Float Translator
//
//  Created by zorth64 on 06/03/26.
//

import SwiftUI

class AppState: ObservableObject {
    static let appName: String = "Float Translator"
    
    @Published var isWindowVisible: Bool = true
    @Published var shouldReadClipboard: Bool = false {
        didSet {
            storedShouldReadClipboard = shouldReadClipboard
            if (!shouldReadClipboard) {
                shouldAutoTranslate = false
            }
        }
    }
    @Published var shouldAutoTranslate: Bool = false {
        didSet {
            storedShouldAutoTranslate = shouldAutoTranslate
        }
    }
    
    var computedShouldAutoTranslate: Bool {
        if (shouldReadClipboard) {
            return shouldAutoTranslate
        } else {
            return false
        }
    }
    
    @Published var dummyDisabledToggle: Bool = false
    
    @AppStorage("readClipboard") private var storedShouldReadClipboard: Bool = false
    @AppStorage("autoTranslate") private var storedShouldAutoTranslate: Bool = false
    
    init() {
        shouldReadClipboard = storedShouldReadClipboard
        shouldAutoTranslate = storedShouldAutoTranslate
    }
    
    func toggleWindow() {
        isWindowVisible.toggle()
    }
}
