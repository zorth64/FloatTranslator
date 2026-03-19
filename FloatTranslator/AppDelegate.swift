//
//  AppDelegate.swift
//  Float Translator
//
//  Created by zorth64 on 05/03/26.
//

import Cocoa
import SwiftUI
import Combine

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @Inject private var appState: AppState
    
    var mainWindow: FloatTranslatorWindow?
    var settingsWindow: NSWindow?
    
    var mainWindowController: WindowController?
    
    var statusItem: NSStatusItem?
    
    @IBOutlet weak var menu: NSMenu?
    @IBOutlet weak var menuItem: NSMenuItem?
    @objc dynamic var menuTitle: String = ""
    
    private var toggleWindowSink: AnyCancellable!
    
    override init() {
        Dependencies.setup()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        bindToggleWindow()
        
        mainWindow = FloatTranslatorWindow()
        
        mainWindowController = WindowController(window: mainWindow!)
        
        mainWindowController!.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let image = NSImage(systemSymbolName: "translate", accessibilityDescription: nil) {
            
            var config = NSImage.SymbolConfiguration(textStyle: .body,
                                                     scale: .medium)
            config = config.applying(.init(pointSize: 15.0, weight: NSFont.Weight.regular))
            statusItem?.button?.image = image.withSymbolConfiguration(config)
        }
        
        if let menu = menu {
            statusItem?.menu = menu
        }
        if let menuItem = menuItem {
            menuTitle = "Hide \(AppState.appName)"
            Task { @MainActor in
                menuItem.setShortcut(for: .toggleWindow)
            }
        }
    }

    @IBAction func showSettingsWindow(_ sender: Any?) {
        if settingsWindow == nil {
            let settingsView = SettingsView()
            settingsWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 450, height: 340),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            settingsWindow?.level = .floating
            settingsWindow?.collectionBehavior = .canJoinAllSpaces
            settingsWindow?.center()
            settingsWindow?.title = "\(AppState.appName) Settings"
            settingsWindow?.isReleasedWhenClosed = false
            settingsWindow?.miniaturize(nil)
            settingsWindow?.zoom(nil)
            settingsWindow?.contentView = NSHostingView(rootView: settingsView)
        }

        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func bindToggleWindow() {
        toggleWindowSink = appState.$isWindowVisible.sink { _ in
            if let window = self.mainWindow {
                if (window.isVisible) {
                    self.menuTitle = "Show \(AppState.appName)"
                    window.orderOut(nil)
                } else {
                    window.makeKeyAndOrderFront(nil)
                    NSApp.activate(ignoringOtherApps: true)
                    self.menuTitle = "Hide \(AppState.appName)"
                }
            }
        }
    }
    
    @IBAction func toggleMainWindowVisibility(_ sender: Any?) {
        NotificationCenter.default.post(name: NSNotification.Name("toggleWindow"), object: nil)
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return false
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}
