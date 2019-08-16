import Foundation
import AppKit

/*SVMPREFS [code generated using svmprefs version 2.0.0]
S main | none | RALL

V Date           | dateVal         | dateVal         | |
V Date as Double | dateAsDoubleVal | dateAsDoubleVal | |

SVMPREFS*/

class MyDateTests {
      var main = UserDefaults.standard

      // MARK: BEGIN main ⬇⬇⬇ AUTO-GENERATED CODE - DO NOT EDIT ⬇⬇⬇
      enum MainKeys {
            static let dateVal = "dateVal"
            static let dateAsDoubleVal = "dateAsDoubleVal"
      }

      var dateVal: Date {
            get {
                  return main.object(forKey: MainKeys.dateVal) as? Date ?? Date.distantPast
            }
            set {
                  main.set(newValue, forKey: MainKeys.dateVal)
            }
      }

      var dateAsDoubleVal: Date {
            get {
                  let interval: TimeInterval = main.double(forKey: MainKeys.dateAsDoubleVal)
                  return Date(timeIntervalSince1970: interval)
            }
            set {
                  let interval = newValue.timeIntervalSince1970
                  main.set(interval, forKey: MainKeys.dateAsDoubleVal)
            }
      }

      func mainRemoveAll() {
            main.removeObject(forKey: MainKeys.dateVal)
            main.removeObject(forKey: MainKeys.dateAsDoubleVal)
      }
      // MARK: END main ⬆⬆⬆ AUTO-GENERATED CODE - DO NOT EDIT ⬆⬆⬆
}
