//
//  TranslationWrapper.swift
//  Float Translator
//
//  Created by zorth64 on 05/03/26.
//

import SwiftUI

struct TranslationView: NSViewControllerRepresentable {

    var text: String

    func makeNSViewController(context: Context) -> NSViewController {
        TranslationBridge.makeTranslationController(text)
    }

    func updateNSViewController(_ vc: NSViewController, context: Context) {}
    
    static func dismantleNSViewController(_ controller: NSViewController, coordinator: ()) {
        controller.view.removeFromSuperview()
        controller.removeFromParent()

        if controller.responds(to: Selector(("dismiss"))) {
            controller.perform(Selector(("dismiss")))
        }
    }
}
