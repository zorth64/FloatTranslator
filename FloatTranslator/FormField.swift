//
//  FormField.swift
//  Float Translator
//
//  Created by zorth64 on 08/03/26.
//

import SwiftUI
import Schwifty

struct FormField<Content: View>: View {
    let title: String
    var titleWidth: CGFloat = 200
    var contentWidth: CGFloat = 250
    var hint: String?
    let content: () -> Content
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 16) {
                Text(title)
                    .textAlign(.leading)
                    .frame(width: titleWidth)
                content()
                    .frame(width: contentWidth)
            }
            if let hint {
                Text(hint)
                    .font(.caption)
                    .textAlign(.leading)
            }
        }
        .frame(width: titleWidth + 16 + contentWidth)
    }
}
