import Foundation
import AppKit

/*SVMPREFS [code generated using svmprefs version 2.0.0]
S main
V Bool  | boolVar1 | boolVar1 | RALL |
V Bool  | boolVar2 | boolVar2 |      |
SVMPREFS*/

class MyNoRemoveAllTests {
  // MARK: BEGIN main ⬇⬇⬇ AUTO-GENERATED CODE - DO NOT EDIT ⬇⬇⬇
  var main = UserDefaults.standard

  enum MainKeys {
    static let boolVar1 = "boolVar1"
    static let boolVar2 = "boolVar2"
  }

  var boolVar1: Bool {
    get {
      return main.bool(forKey: MainKeys.boolVar1)
    }
    set {
      main.set(newValue, forKey: MainKeys.boolVar1)
    }
  }

  var boolVar2: Bool {
    get {
      return main.bool(forKey: MainKeys.boolVar2)
    }
    set {
      main.set(newValue, forKey: MainKeys.boolVar2)
    }
  }

  func mainRemoveAll() {
    main.removeObject(forKey: MainKeys.boolVar1)
  }
  // MARK: END main ⬆⬆⬆ AUTO-GENERATED CODE - DO NOT EDIT ⬆⬆⬆
}
