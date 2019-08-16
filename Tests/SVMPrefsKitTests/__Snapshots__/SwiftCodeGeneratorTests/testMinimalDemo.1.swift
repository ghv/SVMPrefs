import Foundation
import AppKit

/*SVMPREFS [code generated using svmprefs version 2.0.0]
S demo
V Bool | isDemo | demo_key_name | |
SVMPREFS*/

class MyDemoPreferences {

    // ANYTHING HERE IS LEFT UNTOUCHED

    // MARK: BEGIN demo ⬇⬇⬇ AUTO-GENERATED CODE - DO NOT EDIT ⬇⬇⬇
    var demo = UserDefaults.standard

    enum DemoKeys {
        static let isDemo = "demo_key_name"
    }

    var isDemo: Bool {
        get {
            return demo.bool(forKey: DemoKeys.isDemo)
        }
        set {
            demo.set(newValue, forKey: DemoKeys.isDemo)
        }
    }
    // MARK: END demo ⬆⬆⬆ AUTO-GENERATED CODE - DO NOT EDIT ⬆⬆⬆

    // ANYTHING HERE IS LEFT UNTOUCHED
}
