//
//  SettingsView.swift
//  Float Translator
//
//  Created by zorth64 on 06/03/26.
//

import SwiftUI
import KeyboardShortcuts
import Swinject

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 30) {
            ToggleWindowSection()
            ReadClipboardSection()
            AutoTranslateSection()
        }
        .padding(50)
    }
}

private struct ToggleWindowSection: View {
    var body: some View {
        FormField(title: "Toggle Window Shortcut") {
            KeyboardShortcuts.Recorder("", name: .toggleWindow)
                .positioned(.trailing)
        }
    }
}

private struct ReadClipboardSection: View {
    @StateObject private var appState: AppState = Container.main.resolve(AppState.self)!
    
    var body: some View {
        FormField(title: "Read Clipboard", hint: "Show clipboard contents in the text field when the window open.") {
            Toggle(isOn: $appState.shouldReadClipboard, label: { EmptyView() })
                .toggleStyle(.switch)
                .positioned(.trailing)
        }
    }
}

private struct AutoTranslateSection: View {
    @StateObject private var appState: AppState = Container.main.resolve(AppState.self)!
    
    var body: some View {
        if (appState.shouldReadClipboard) {
            FormField(title: "Auto Translate", hint: "Automatically translate the text when the window open.") {
                Toggle(isOn: $appState.shouldAutoTranslate, label: { EmptyView() })
                    .toggleStyle(.switch)
                    .positioned(.trailing)
            }
        } else {
            FormField(title: "Auto Translate", hint: "Automatically translate the text when the window open.") {
                Toggle(isOn: $appState.dummyDisabledToggle, label: { EmptyView() })
                    .toggleStyle(.switch)
                    .disabled(true)
                    .positioned(.trailing)
            }
        }
    }
}

extension KeyboardShortcuts.Name {
    static let toggleWindow = Self("toggleWindow")
}
