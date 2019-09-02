import Foundation
import AppKit

/*SVMPREFS [code generated using svmprefs version 2.0.0]
S keypath
V [String] | primaryList   | app.primaryList   | |
V [String] | secondaryList | app.secondaryList | |
SVMPREFS*/

class KeyPathPrefs {
    // MARK: BEGIN keypath ⬇⬇⬇ AUTO-GENERATED CODE - DO NOT EDIT ⬇⬇⬇
    var keypath = UserDefaults.standard

    enum KeypathKeys {
        static let primaryList = "app.primaryList"
        static let secondaryList = "app.secondaryList"
    }

    var primaryList: [String] {
        get {
            return keypath.stringArray(forKey: KeypathKeys.primaryList) ?? [String]()
        }
        set {
            keypath.set(newValue, forKey: KeypathKeys.primaryList)
        }
    }

    var secondaryList: [String] {
        get {
            return keypath.stringArray(forKey: KeypathKeys.secondaryList) ?? [String]()
        }
        set {
            keypath.set(newValue, forKey: KeypathKeys.secondaryList)
        }
    }
    // MARK: END keypath ⬆⬆⬆ AUTO-GENERATED CODE - DO NOT EDIT ⬆⬆⬆
}

// Somewhere in your app...
func demo() {
    // A function that needs to use one of several preferences
    func processList(keyPath: KeyPath<KeyPathPrefs, [String]>) {
        let prefs = KeyPathPrefs()
        let list = prefs[keyPath: keyPath]
        // Do something with this list...
    }

    // How you call it:
    processList(keyPath: \.primaryList)
    processList(keyPath: \.secondaryList)
}
