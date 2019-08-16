import Foundation
import AppKit

/*SVMPREFS [code generated using svmprefs version 2.0.0]
S main  | |
V Bool  | boolVar  | boolVar  | OBJC,REM,ISSET |
S main1 | |
V Bool  | boolVar2 | boolVar2 | OBJC,REM,ISSET |
S main2 | | RALL
V Bool  | boolVar3 | boolVar3 | OBJC,REM,ISSET |
SVMPREFS*/

class MyCompoundCodeMarakTests {
  // MARK: BEGIN main,main1,main2 ⬇⬇⬇ AUTO-GENERATED CODE - DO NOT EDIT ⬇⬇⬇
  // main:
  var main = UserDefaults.standard

  enum MainKeys {
    static let boolVar = "boolVar"
  }

  @objc var boolVar: Bool {
    get {
      return main.bool(forKey: MainKeys.boolVar)
    }
    set {
      main.set(newValue, forKey: MainKeys.boolVar)
    }
  }

  @objc var isBoolVarSet: Bool {
    return main.object(forKey: MainKeys.boolVar) != nil
  }

  @objc func removeBoolVarPref() {
    main.removeObject(forKey: MainKeys.boolVar)
  }

  // main1:
  var main1 = UserDefaults.standard

  enum Main1Keys {
    static let boolVar2 = "boolVar2"
  }

  @objc var boolVar2: Bool {
    get {
      return main1.bool(forKey: Main1Keys.boolVar2)
    }
    set {
      main1.set(newValue, forKey: Main1Keys.boolVar2)
    }
  }

  @objc var isBoolVar2Set: Bool {
    return main1.object(forKey: Main1Keys.boolVar2) != nil
  }

  @objc func removeBoolVar2Pref() {
    main1.removeObject(forKey: Main1Keys.boolVar2)
  }

  // main2:
  var main2 = UserDefaults.standard

  enum Main2Keys {
    static let boolVar3 = "boolVar3"
  }

  @objc var boolVar3: Bool {
    get {
      return main2.bool(forKey: Main2Keys.boolVar3)
    }
    set {
      main2.set(newValue, forKey: Main2Keys.boolVar3)
    }
  }

  @objc var isBoolVar3Set: Bool {
    return main2.object(forKey: Main2Keys.boolVar3) != nil
  }

  @objc func removeBoolVar3Pref() {
    main2.removeObject(forKey: Main2Keys.boolVar3)
  }

  func main2RemoveAll() {
    main2.removeObject(forKey: Main2Keys.boolVar3)
  }
  // MARK: END main,main1,main2 ⬆⬆⬆ AUTO-GENERATED CODE - DO NOT EDIT ⬆⬆⬆
}
