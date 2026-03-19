//
//  ContentView.swift
//  Float Translator
//
//  Created by zorth64 on 05/03/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Inject private var appState: AppState
    
    @State private var keyState: KeyState = KeyState()
    
    @State private var inputText: String
    
    @State private var isWindowFocused: Bool = true
    @FocusState private var isTextFieldFocused: Bool
    @State private var animateFocus: Bool = false
    
    @State var showTranslation: Bool = false
    @State private var translationID = 0
    
    init(showTranslation: Bool) {
        self.showTranslation = showTranslation
        
        let text = getClipboardAsString()        
        _inputText = State(initialValue: text)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                Text("Enter text to translate:")
                    .padding(.bottom, 3)
                TextEditor(text: $inputText)
                    .font(Font.system(size: 15))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 2)
                    .focused($isTextFieldFocused)
                    .textEditorStyle(.plain)
                    .background {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(colorScheme == .dark ? Color.black.opacity(0.25) : Color.white.opacity(0.85))
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.accentColor.opacity(animateFocus ? 0.7 : 0), lineWidth: animateFocus ? 8 : 30)
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black)
                                    .blendMode(.destinationOut)
                            }
                            .compositingGroup()
                        }
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.primary.opacity(0.18), lineWidth: 2)
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black)
                                    .blendMode(.destinationOut)
                            }
                            .compositingGroup()
                        }
                    }
                    .onAppear {
                        isTextFieldFocused = true
                    }
                    .onChange(of: isTextFieldFocused) {
                        if (isTextFieldFocused) {
                            withAnimation(.easeIn(duration: 0.15)) {
                                animateFocus = isTextFieldFocused
                            }
                        }
                    }
                    .onChange(of: isWindowFocused) {
                        withAnimation(isWindowFocused ? .easeIn(duration: 0.15) : .easeOut(duration: 0.1)) {
                            animateFocus = isWindowFocused
                        }
                    }
                    .onChange(of: appState.computedShouldAutoTranslate) { _, newValue in
                        showTranslation = newValue
                    }
                
                HStack(alignment: .bottom) {
                    Spacer()
                    
                    Button("Translate") {
                        showTranslation = true
                        translationID += 1
                    }
                }
                .padding(.top, 4)
                .padding(.bottom, 10)
            }
            .padding(.top, 14)
            .padding(.horizontal, 14)
            .frame(minHeight: 200)

            Divider()
                .overlay(Color.primary.opacity(0.07))
                .background(Color(nsColor: NSColor.windowBackgroundColor))
            
            ZStack(alignment: .topLeading) {
                
                VStack(alignment: .leading, spacing: 10) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.primary.opacity(0.168))
                        .frame(width: 75, height: 9)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.primary.opacity(0.168))
                        .frame(width: 343, height: 16)
                        .padding(.top, 4)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.primary.opacity(0.168))
                        .frame(width: 95, height: 16)
                    
                    
                    Divider()
                        .overlay(Color.primary.opacity(0.07))
                        .background(Color(nsColor: NSColor.windowBackgroundColor))
                        .padding(.top, 7)
                        .padding(.bottom, 6)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.accentColor.opacity(0.168))
                        .frame(width: 75, height: 9)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.accentColor.opacity(0.168))
                        .frame(width: 343, height: 16)
                        .padding(.top, 4)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.accentColor.opacity(0.168))
                        .frame(width: 95, height: 16)
                    
                    Spacer()
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.primary.opacity(0.085))
                            .frame(width: 116, height: 18)
                    }
                    .frame(height: 51)
                    
                    
                }
                .padding(.top, 16)
                .padding(.horizontal, 18)
                
                if (showTranslation) {
                    TranslationView(text: inputText)
                        .id(translationID)
                        .offset(x: 2)
                        .background(Color(nsColor: NSColor.windowBackgroundColor))
                }
                
                VStack(spacing: 0) {
                    VStack {
                    }
                    .frame(width: 379, height: 248)
                    
                    Divider()
                        .overlay(Color.primary.opacity(0.07))
                        .background(Color(nsColor: NSColor.windowBackgroundColor))
                    
                    HStack {
                    }
                    .frame(height: 51)
                }
                
            }
            .frame(height: 300, alignment: .bottom)
        }
        .frame(maxWidth: 379, minHeight: 518, maxHeight: 750, alignment: .top)
        .background(Color(nsColor: NSColor.windowBackgroundColor))
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { (_) in
            isWindowFocused = true
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didResignKeyNotification)) { (_) in
            isWindowFocused = false
        }
        .onChange(of: appState.isWindowVisible) { _, newValue in
            Swift.print("Value: \(newValue)")
            if (newValue) {
                inputText = getClipboardAsString()
            } else {
                showTranslation = false
            }
        }
        .onChange(of: inputText) {
            if (showTranslation) {
                showTranslation.toggle()
            }
        }
    }
}

fileprivate func getClipboardAsString() -> String {
    @Inject var appState: AppState
    
    if (appState.shouldReadClipboard) {
        let pasteboard = NSPasteboard.general
        
        return pasteboard.string(forType: .string) ?? ""
    } else {
        return ""
    }
}

#Preview {
    ContentView(showTranslation: false)
}
