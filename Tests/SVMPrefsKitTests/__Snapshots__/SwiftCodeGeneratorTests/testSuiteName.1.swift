import Foundation
import AppKit

/*SVMPREFS [code generated using svmprefs version 2.0.0]
S main  | "someSuiteName"    | RALL
V Bool  | boolVar            | boolVar  | OBJC,REM,ISSET |
S main1 | getSuiteName()     | RALL
V Bool  | boolVar2           | boolVar2 | OBJC,REM,ISSET |
S main2 | "\(someSuiteName)" | RALL
V Bool  | boolVar3           | boolVar3 | OBJC,REM,ISSET |
SVMPREFS*/

class MySuiteNameTests {
  static let someSuiteName = "someSuiteName"

  static func getSuiteName() -> String {
    "someSuiteName"
  }

  // MARK: BEGIN main ⬇⬇⬇ AUTO-GENERATED CODE - DO NOT EDIT ⬇⬇⬇
  var main = UserDefaults(suiteName: "someSuiteName")!

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

  func mainRemoveAll() {
    main.removeObject(forKey: MainKeys.boolVar)
  }
  // MARK: END main ⬆⬆⬆ AUTO-GENERATED CODE - DO NOT EDIT ⬆⬆⬆

  // MARK: BEGIN main1 ⬇⬇⬇ AUTO-GENERATED CODE - DO NOT EDIT ⬇⬇⬇
  var main1 = UserDefaults(suiteName: getSuiteName())!

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

  func main1RemoveAll() {
    main1.removeObject(forKey: Main1Keys.boolVar2)
  }
  // MARK: END main1 ⬆⬆⬆ AUTO-GENERATED CODE - DO NOT EDIT ⬆⬆⬆

  // MARK: BEGIN main2 ⬇⬇⬇ AUTO-GENERATED CODE - DO NOT EDIT ⬇⬇⬇
  var main2 = UserDefaults(suiteName: "\(someSuiteName)")!

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
  // MARK: END main2 ⬆⬆⬆ AUTO-GENERATED CODE - DO NOT EDIT ⬆⬆⬆
}
