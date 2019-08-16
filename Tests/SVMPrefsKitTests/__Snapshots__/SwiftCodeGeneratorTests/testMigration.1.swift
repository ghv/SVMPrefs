import Foundation
import AppKit

/*SVMPREFS [code generated using svmprefs version 2.0.0]
S main | | RALL

V Bool | boolVar1    | boolVar2 | IS |
V Bool | hasBoolVar2 | boolVar2 | |
V Bool | boolVar3    | boolVar3 | |
V Bool | boolVar4    | boolVar4 | |

S copy | | RALL

V Bool | boolVar3 | boolVar3 | |
V Bool | boolVar4 | boolVar4 | |

M main | copy   | boolVar3 | boolVar3
M main | copy   | boolVar4 | boolVar4
M main | delete | hasBoolVar2

SVMPREFS*/

class MyMigrationTests {
    // MARK: BEGIN migrate ⬇⬇⬇ AUTO-GENERATED CODE - DO NOT EDIT ⬇⬇⬇
    func migrate() {
        if let value = main.object(forKey: MainKeys.boolVar3) {
            copy.set(value, forKey: CopyKeys.boolVar3)
            main.removeObject(forKey: MainKeys.boolVar3)
        }
        if let value = main.object(forKey: MainKeys.boolVar4) {
            copy.set(value, forKey: CopyKeys.boolVar4)
            main.removeObject(forKey: MainKeys.boolVar4)
        }
        if main.object(forKey: MainKeys.hasBoolVar2) != nil {
            main.removeObject(forKey: MainKeys.hasBoolVar2)
        }
    }
    // MARK: END migrate ⬆⬆⬆ AUTO-GENERATED CODE - DO NOT EDIT ⬆⬆⬆

    // MARK: BEGIN main ⬇⬇⬇ AUTO-GENERATED CODE - DO NOT EDIT ⬇⬇⬇
    var main = UserDefaults.standard

    enum MainKeys {
        static let isBoolVar1 = "boolVar2"
        static let hasBoolVar2 = "boolVar2"
        static let boolVar3 = "boolVar3"
        static let boolVar4 = "boolVar4"
    }

    var isBoolVar1: Bool {
        get {
            return main.bool(forKey: MainKeys.isBoolVar1)
        }
        set {
            main.set(newValue, forKey: MainKeys.isBoolVar1)
        }
    }

    func mainRemoveAll() {
        main.removeObject(forKey: MainKeys.isBoolVar1)
        main.removeObject(forKey: MainKeys.hasBoolVar2)
        main.removeObject(forKey: MainKeys.boolVar3)
        main.removeObject(forKey: MainKeys.boolVar4)
    }
    // MARK: END main ⬆⬆⬆ AUTO-GENERATED CODE - DO NOT EDIT ⬆⬆⬆

    // MARK: BEGIN copy ⬇⬇⬇ AUTO-GENERATED CODE - DO NOT EDIT ⬇⬇⬇
    var copy = UserDefaults.standard

    enum CopyKeys {
        static let boolVar3 = "boolVar3"
        static let boolVar4 = "boolVar4"
    }

    var boolVar3: Bool {
        get {
            return copy.bool(forKey: CopyKeys.boolVar3)
        }
        set {
            copy.set(newValue, forKey: CopyKeys.boolVar3)
        }
    }

    var boolVar4: Bool {
        get {
            return copy.bool(forKey: CopyKeys.boolVar4)
        }
        set {
            copy.set(newValue, forKey: CopyKeys.boolVar4)
        }
    }

    func copyRemoveAll() {
        copy.removeObject(forKey: CopyKeys.boolVar3)
        copy.removeObject(forKey: CopyKeys.boolVar4)
    }
    // MARK: END copy ⬆⬆⬆ AUTO-GENERATED CODE - DO NOT EDIT ⬆⬆⬆
}
