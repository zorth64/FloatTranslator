//
//  FloatTranslatorWindow.swift
//  Float Translator
//
//  Created by zorth64 on 18/03/26.
//

import SwiftUI

class FloatTranslatorWindow: NSWindow, NSWindowDelegate {
    @Inject private var appState: AppState
    
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
    
    func setup() {
        title = AppState.appName
        collectionBehavior = [.canJoinAllSpaces, .fullScreenDisallowsTiling]
        level = .floating
        styleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView]
        minSize = NSSize(width: 379, height: 518)
        maxSize = NSSize(width: 379, height: 750)
        titleVisibility = .visible
        titlebarAppearsTransparent = false
        isMovableByWindowBackground = false
        isReleasedWhenClosed = false
        delegate = self
        restoreSizeAndPosition()
    }
    
    func windowWillClose(_ notification: Notification) {
        appState.isWindowVisible = false
    }
    
    func windowDidMove(_ notification: Notification) {
        let origin = self.frame.origin
        saveWindowPosition(origin)
    }
    
    func windowDidResize(_ notification: Notification) {
        let frame = self.frame
        saveWindowSize(frame.size)
        saveWindowPosition(frame.origin)
    }
    
    private func restoreSizeAndPosition() {
        if (UserDefaults.standard.value(forKey: "windowPositionX") != nil &&
            UserDefaults.standard.value(forKey: "windowPositionY") != nil &&
            UserDefaults.standard.value(forKey: "windowWidth") != nil &&
            UserDefaults.standard.value(forKey: "windowHeight") != nil) {
            
            let x = UserDefaults.standard.double(forKey: "windowPositionX")
            let y = UserDefaults.standard.double(forKey: "windowPositionY")
            let width = UserDefaults.standard.double(forKey: "windowWidth")
            let height = UserDefaults.standard.double(forKey: "windowHeight")
            
            let rect = NSRect(x: x, y: y, width: width, height: height)
            
            setFrame(rect, display: true)
        } else {
            center()
        }
    }
    
    private func saveWindowPosition(_ origin: CGPoint) {
        UserDefaults.standard.setValue(origin.x, forKey: "windowPositionX")
        UserDefaults.standard.setValue(origin.y, forKey: "windowPositionY")
    }
    
    private func saveWindowSize(_ size: CGSize) {
        UserDefaults.standard.setValue(size.width, forKey: "windowWidth")
        UserDefaults.standard.setValue(size.height, forKey: "windowHeight")
    }
    
}

class WindowController: NSWindowController {
    @Inject private var appState: AppState
    
    init(window: FloatTranslatorWindow) {
        super.init(window: window)
        let contentView = ContentView(showTranslation: appState.computedShouldAutoTranslate)
            .frame(minWidth: 379, minHeight: 518)
        
        window.contentView = NSHostingView(rootView: contentView)
        window.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
