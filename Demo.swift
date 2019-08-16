/*SVMPREFS [code generated using svmprefs version 2.0.0]
S demo | | RALL

V Bool      | boolVar      | boolVar      | OBJC,REM,ISSET |
V Double    | doubleVar    | doubleVar    | OBJC,REM,ISSET |
V Float     | floatVar     | floatVar     | OBJC,REM,ISSET |
V Int       | intVar       | intVar       | OBJC,REM,ISSET |

V Any?      | optAny       | optAny       | OBJC,REM,ISSET |

V String?   | optStringVar | optStringVar | OBJC,REM,ISSET |
V String    | stringVar    | stringVar    | OBJC,REM,ISSET |

V Data?     | optDataVar   | optDataVar   | OBJC,REM,ISSET |
V Data      | dataVar      | dataVar      | OBJC,REM,ISSET |

V Date?     | optDateVar   | optDateVar   | OBJC,REM,ISSET |
V Date      | dateVar      | dateVar      | OBJC,REM,ISSET |

V [Any]     | anyArray     | anyArray     | OBJC,REM,ISSET |
V [Bool]    | boolArray    | boolArray    | OBJC,REM,ISSET |
V [Date]    | dateArray    | dateArray    | OBJC,REM,ISSET |
V [Double]  | doubleArray  | doubleArray  | OBJC,REM,ISSET |
V [Float]   | floatArray   | floatArray   | OBJC,REM,ISSET |
V [Int]     | intArray     | intArray     | OBJC,REM,ISSET |
V [String]  | stringArray  | stringArray  | OBJC,REM,ISSET |

V [Bool]?   | optBoolArray    | optBoolArray   | OBJC,REM,ISSET |
V [Date]?   | optDateArray    | optDateArray   | OBJC,REM,ISSET |
V [Double]? | optDoubleArray  | optDoubleArray | OBJC,REM,ISSET |
V [Float ]? | optFloatArray   | optFloatArray  | OBJC,REM,ISSET |
V [Int]?    | optIntArray     | optIntArray    | OBJC,REM,ISSET |
V [String]? | optStringArray  | optStringArray | OBJC,REM,ISSET |

V [[String: Any]]  | arrayOfStringToAnyDictionary    | arrayOfStringToAnyDictionary    | OBJC,REM,ISSET |
V [[String: Any]]? | optArrayOfStringToAnyDictionary | optArrayOfStringToAnyDictionary | OBJC,REM,ISSET |

V [String: Any]    | stringToAnyDictionary    | stringToAnyDictionary    | OBJC,REM,ISSET |
V [String: Any]?   | optStringToAnyDictionary | optStringToAnyDictionary | OBJC,REM,ISSET |

V URL?| optUrlVar | optUrlVar | OBJC,REM,ISSET |

S extra     |               | RALL
V Bool      | boolVar2      | boolVar2      | OBJC,REM,ISSET |
V Double    | doubleVar2    | doubleVar2    | OBJC,REM,ISSET |
V Float     | floatVar2     | floatVar2     | OBJC,REM,ISSET |
V Int       | intVar2       | intVar2       | OBJC,REM,ISSET |

M demo | extra | boolVar    | boolVar2
M demo | extra | doubleVar  | doubleVar2
M demo | extra | floatVar   | floatVar2
M demo | extra | intVar     | intVar2

SVMPREFS*/

// swiftlint:disable file_length
// swiftlint:disable:next type_body_length
class MyDemoPreferences {
    // ANYTHING HERE IS LEFT UNTOUCHED
    // MARK: BEGIN demo ⬇⬇⬇ AUTO-GENERATED CODE - DO NOT EDIT ⬇⬇⬇
    var demo = UserDefaults.standard

    enum DemoKeys {
        static let boolVar = "boolVar"
        static let doubleVar = "doubleVar"
        static let floatVar = "floatVar"
        static let intVar = "intVar"
        static let optAny = "optAny"
        static let optStringVar = "optStringVar"
        static let stringVar = "stringVar"
        static let optDataVar = "optDataVar"
        static let dataVar = "dataVar"
        static let optDateVar = "optDateVar"
        static let dateVar = "dateVar"
        static let anyArray = "anyArray"
        static let boolArray = "boolArray"
        static let dateArray = "dateArray"
        static let doubleArray = "doubleArray"
        static let floatArray = "floatArray"
        static let intArray = "intArray"
        static let stringArray = "stringArray"
        static let optBoolArray = "optBoolArray"
        static let optDateArray = "optDateArray"
        static let optDoubleArray = "optDoubleArray"
        static let optFloatArray = "optFloatArray"
        static let optIntArray = "optIntArray"
        static let optStringArray = "optStringArray"
        static let arrayOfStringToAnyDictionary = "arrayOfStringToAnyDictionary"
        static let optArrayOfStringToAnyDictionary = "optArrayOfStringToAnyDictionary"
        static let stringToAnyDictionary = "stringToAnyDictionary"
        static let optStringToAnyDictionary = "optStringToAnyDictionary"
        static let optUrlVar = "optUrlVar"
    }

    @objc var optAny: Any? {
        get {
            return demo.object(forKey: DemoKeys.optAny)
        }
        set {
            if let newValue = newValue {
                demo.set(newValue, forKey: DemoKeys.optAny)
            } else {
                demo.removeObject(forKey: DemoKeys.optAny)
            }
        }
    }

    @objc var isOptAnySet: Bool {
        return demo.object(forKey: DemoKeys.optAny) != nil
    }

    @objc func removeOptAnyPref() {
        demo.removeObject(forKey: DemoKeys.optAny)
    }

    @objc var optStringVar: String? {
        get {
            return demo.string(forKey: DemoKeys.optStringVar)
        }
        set {
            if let newValue = newValue {
                demo.set(newValue, forKey: DemoKeys.optStringVar)
            } else {
                demo.removeObject(forKey: DemoKeys.optStringVar)
            }
        }
    }

    @objc var isOptStringVarSet: Bool {
        return demo.object(forKey: DemoKeys.optStringVar) != nil
    }

    @objc func removeOptStringVarPref() {
        demo.removeObject(forKey: DemoKeys.optStringVar)
    }

    @objc var stringVar: String {
        get {
            return demo.string(forKey: DemoKeys.stringVar) ?? ""
        }
        set {
            demo.set(newValue, forKey: DemoKeys.stringVar)
        }
    }

    @objc var isStringVarSet: Bool {
        return demo.object(forKey: DemoKeys.stringVar) != nil
    }

    @objc func removeStringVarPref() {
        demo.removeObject(forKey: DemoKeys.stringVar)
    }

    @objc var optDataVar: Data? {
        get {
            return demo.data(forKey: DemoKeys.optDataVar)
        }
        set {
            if let newValue = newValue {
                demo.set(newValue, forKey: DemoKeys.optDataVar)
            } else {
                demo.removeObject(forKey: DemoKeys.optDataVar)
            }
        }
    }

    @objc var isOptDataVarSet: Bool {
        return demo.object(forKey: DemoKeys.optDataVar) != nil
    }

    @objc func removeOptDataVarPref() {
        demo.removeObject(forKey: DemoKeys.optDataVar)
    }

    @objc var dataVar: Data {
        get {
            return demo.data(forKey: DemoKeys.dataVar) ?? Data()
        }
        set {
            demo.set(newValue, forKey: DemoKeys.dataVar)
        }
    }

    @objc var isDataVarSet: Bool {
        return demo.object(forKey: DemoKeys.dataVar) != nil
    }

    @objc func removeDataVarPref() {
        demo.removeObject(forKey: DemoKeys.dataVar)
    }

    @objc var optDateVar: Date? {
        get {
            return demo.object(forKey: DemoKeys.optDateVar) as? Date
        }
        set {
            if let newValue = newValue {
                demo.set(newValue, forKey: DemoKeys.optDateVar)
            } else {
                demo.removeObject(forKey: DemoKeys.optDateVar)
            }
        }
    }

    @objc var isOptDateVarSet: Bool {
        return demo.object(forKey: DemoKeys.optDateVar) != nil
    }

    @objc func removeOptDateVarPref() {
        demo.removeObject(forKey: DemoKeys.optDateVar)
    }

    @objc var dateVar: Date {
        get {
            return demo.object(forKey: DemoKeys.dateVar) as? Date ?? Date.distantPast
        }
        set {
            demo.set(newValue, forKey: DemoKeys.dateVar)
        }
    }

    @objc var isDateVarSet: Bool {
        return demo.object(forKey: DemoKeys.dateVar) != nil
    }

    @objc func removeDateVarPref() {
        demo.removeObject(forKey: DemoKeys.dateVar)
    }

    @objc var anyArray: [Any] {
        get {
            return demo.array(forKey: DemoKeys.anyArray) ?? [Any]()
        }
        set {
            demo.set(newValue, forKey: DemoKeys.anyArray)
        }
    }

    @objc var isAnyArraySet: Bool {
        return demo.object(forKey: DemoKeys.anyArray) != nil
    }

    @objc func removeAnyArrayPref() {
        demo.removeObject(forKey: DemoKeys.anyArray)
    }

    @objc var boolArray: [Bool] {
        get {
            return demo.array(forKey: DemoKeys.boolArray) as? [Bool] ?? [Bool]()
        }
        set {
            demo.set(newValue, forKey: DemoKeys.boolArray)
        }
    }

    @objc var isBoolArraySet: Bool {
        return demo.object(forKey: DemoKeys.boolArray) != nil
    }

    @objc func removeBoolArrayPref() {
        demo.removeObject(forKey: DemoKeys.boolArray)
    }

    @objc var dateArray: [Date] {
        get {
            return demo.array(forKey: DemoKeys.dateArray) as? [Date] ?? [Date]()
        }
        set {
            demo.set(newValue, forKey: DemoKeys.dateArray)
        }
    }

    @objc var isDateArraySet: Bool {
        return demo.object(forKey: DemoKeys.dateArray) != nil
    }

    @objc func removeDateArrayPref() {
        demo.removeObject(forKey: DemoKeys.dateArray)
    }

    @objc var doubleArray: [Double] {
        get {
            return demo.array(forKey: DemoKeys.doubleArray) as? [Double] ?? [Double]()
        }
        set {
            demo.set(newValue, forKey: DemoKeys.doubleArray)
        }
    }

    @objc var isDoubleArraySet: Bool {
        return demo.object(forKey: DemoKeys.doubleArray) != nil
    }

    @objc func removeDoubleArrayPref() {
        demo.removeObject(forKey: DemoKeys.doubleArray)
    }

    @objc var floatArray: [Float] {
        get {
            return demo.array(forKey: DemoKeys.floatArray) as? [Float] ?? [Float]()
        }
        set {
            demo.set(newValue, forKey: DemoKeys.floatArray)
        }
    }

    @objc var isFloatArraySet: Bool {
        return demo.object(forKey: DemoKeys.floatArray) != nil
    }

    @objc func removeFloatArrayPref() {
        demo.removeObject(forKey: DemoKeys.floatArray)
    }

    @objc var intArray: [Int] {
        get {
            return demo.array(forKey: DemoKeys.intArray) as? [Int] ?? [Int]()
        }
        set {
            demo.set(newValue, forKey: DemoKeys.intArray)
        }
    }

    @objc var isIntArraySet: Bool {
        return demo.object(forKey: DemoKeys.intArray) != nil
    }

    @objc func removeIntArrayPref() {
        demo.removeObject(forKey: DemoKeys.intArray)
    }

    @objc var stringArray: [String] {
        get {
            return demo.stringArray(forKey: DemoKeys.stringArray) ?? [String]()
        }
        set {
            demo.set(newValue, forKey: DemoKeys.stringArray)
        }
    }

    @objc var isStringArraySet: Bool {
        return demo.object(forKey: DemoKeys.stringArray) != nil
    }

    @objc func removeStringArrayPref() {
        demo.removeObject(forKey: DemoKeys.stringArray)
    }

    @objc var optBoolArray: [Bool]? {
        get {
            return demo.array(forKey: DemoKeys.optBoolArray) as? [Bool]
        }
        set {
            if let newValue = newValue {
                demo.set(newValue, forKey: DemoKeys.optBoolArray)
            } else {
                demo.removeObject(forKey: DemoKeys.optBoolArray)
            }
        }
    }

    @objc var isOptBoolArraySet: Bool {
        return demo.object(forKey: DemoKeys.optBoolArray) != nil
    }

    @objc func removeOptBoolArrayPref() {
        demo.removeObject(forKey: DemoKeys.optBoolArray)
    }

    @objc var optDateArray: [Date]? {
        get {
            return demo.array(forKey: DemoKeys.optDateArray) as? [Date]
        }
        set {
            if let newValue = newValue {
                demo.set(newValue, forKey: DemoKeys.optDateArray)
            } else {
                demo.removeObject(forKey: DemoKeys.optDateArray)
            }
        }
    }

    @objc var isOptDateArraySet: Bool {
        return demo.object(forKey: DemoKeys.optDateArray) != nil
    }

    @objc func removeOptDateArrayPref() {
        demo.removeObject(forKey: DemoKeys.optDateArray)
    }

    @objc var optDoubleArray: [Double]? {
        get {
            return demo.array(forKey: DemoKeys.optDoubleArray) as? [Double]
        }
        set {
            if let newValue = newValue {
                demo.set(newValue, forKey: DemoKeys.optDoubleArray)
            } else {
                demo.removeObject(forKey: DemoKeys.optDoubleArray)
            }
        }
    }

    @objc var isOptDoubleArraySet: Bool {
        return demo.object(forKey: DemoKeys.optDoubleArray) != nil
    }

    @objc func removeOptDoubleArrayPref() {
        demo.removeObject(forKey: DemoKeys.optDoubleArray)
    }

    @objc var optFloatArray: [Float ]? {
        get {
            return demo.array(forKey: DemoKeys.optFloatArray) as? [Float ]
        }
        set {
            if let newValue = newValue {
                demo.set(newValue, forKey: DemoKeys.optFloatArray)
            } else {
                demo.removeObject(forKey: DemoKeys.optFloatArray)
            }
        }
    }

    @objc var isOptFloatArraySet: Bool {
        return demo.object(forKey: DemoKeys.optFloatArray) != nil
    }

    @objc func removeOptFloatArrayPref() {
        demo.removeObject(forKey: DemoKeys.optFloatArray)
    }

    @objc var optIntArray: [Int]? {
        get {
            return demo.array(forKey: DemoKeys.optIntArray) as? [Int]
        }
        set {
            if let newValue = newValue {
                demo.set(newValue, forKey: DemoKeys.optIntArray)
            } else {
                demo.removeObject(forKey: DemoKeys.optIntArray)
            }
        }
    }

    @objc var isOptIntArraySet: Bool {
        return demo.object(forKey: DemoKeys.optIntArray) != nil
    }

    @objc func removeOptIntArrayPref() {
        demo.removeObject(forKey: DemoKeys.optIntArray)
    }

    @objc var optStringArray: [String]? {
        get {
            return demo.stringArray(forKey: DemoKeys.optStringArray)
        }
        set {
            if let newValue = newValue {
                demo.set(newValue, forKey: DemoKeys.optStringArray)
            } else {
                demo.removeObject(forKey: DemoKeys.optStringArray)
            }
        }
    }

    @objc var isOptStringArraySet: Bool {
        return demo.object(forKey: DemoKeys.optStringArray) != nil
    }

    @objc func removeOptStringArrayPref() {
        demo.removeObject(forKey: DemoKeys.optStringArray)
    }

    @objc var arrayOfStringToAnyDictionary: [[String: Any]] {
        get {
            return demo.array(forKey: DemoKeys.arrayOfStringToAnyDictionary) as? [[String: Any]] ?? [[String: Any]]()
        }
        set {
            demo.set(newValue, forKey: DemoKeys.arrayOfStringToAnyDictionary)
        }
    }

    @objc var isArrayOfStringToAnyDictionarySet: Bool {
        return demo.object(forKey: DemoKeys.arrayOfStringToAnyDictionary) != nil
    }

    @objc func removeArrayOfStringToAnyDictionaryPref() {
        demo.removeObject(forKey: DemoKeys.arrayOfStringToAnyDictionary)
    }

    @objc var optArrayOfStringToAnyDictionary: [[String: Any]]? {
        get {
            return demo.array(forKey: DemoKeys.optArrayOfStringToAnyDictionary) as? [[String: Any]]
        }
        set {
            if let newValue = newValue {
                demo.set(newValue, forKey: DemoKeys.optArrayOfStringToAnyDictionary)
            } else {
                demo.removeObject(forKey: DemoKeys.optArrayOfStringToAnyDictionary)
            }
        }
    }

    @objc var isOptArrayOfStringToAnyDictionarySet: Bool {
        return demo.object(forKey: DemoKeys.optArrayOfStringToAnyDictionary) != nil
    }

    @objc func removeOptArrayOfStringToAnyDictionaryPref() {
        demo.removeObject(forKey: DemoKeys.optArrayOfStringToAnyDictionary)
    }

    @objc var stringToAnyDictionary: [String: Any] {
        get {
            return demo.dictionary(forKey: DemoKeys.stringToAnyDictionary) ?? [String: Any]()
        }
        set {
            demo.set(newValue, forKey: DemoKeys.stringToAnyDictionary)
        }
    }

    @objc var isStringToAnyDictionarySet: Bool {
        return demo.object(forKey: DemoKeys.stringToAnyDictionary) != nil
    }

    @objc func removeStringToAnyDictionaryPref() {
        demo.removeObject(forKey: DemoKeys.stringToAnyDictionary)
    }

    @objc var optStringToAnyDictionary: [String: Any]? {
        get {
            return demo.dictionary(forKey: DemoKeys.optStringToAnyDictionary)
        }
        set {
            if let newValue = newValue {
                demo.set(newValue, forKey: DemoKeys.optStringToAnyDictionary)
            } else {
                demo.removeObject(forKey: DemoKeys.optStringToAnyDictionary)
            }
        }
    }

    @objc var isOptStringToAnyDictionarySet: Bool {
        return demo.object(forKey: DemoKeys.optStringToAnyDictionary) != nil
    }

    @objc func removeOptStringToAnyDictionaryPref() {
        demo.removeObject(forKey: DemoKeys.optStringToAnyDictionary)
    }

    @objc var optUrlVar: URL? {
        get {
            return demo.url(forKey: DemoKeys.optUrlVar)
        }
        set {
            if let newValue = newValue {
                demo.set(newValue, forKey: DemoKeys.optUrlVar)
            } else {
                demo.removeObject(forKey: DemoKeys.optUrlVar)
            }
        }
    }

    @objc var isOptUrlVarSet: Bool {
        return demo.object(forKey: DemoKeys.optUrlVar) != nil
    }

    @objc func removeOptUrlVarPref() {
        demo.removeObject(forKey: DemoKeys.optUrlVar)
    }

    func demoRemoveAll() {
        demo.removeObject(forKey: DemoKeys.boolVar)
        demo.removeObject(forKey: DemoKeys.doubleVar)
        demo.removeObject(forKey: DemoKeys.floatVar)
        demo.removeObject(forKey: DemoKeys.intVar)
        demo.removeObject(forKey: DemoKeys.optAny)
        demo.removeObject(forKey: DemoKeys.optStringVar)
        demo.removeObject(forKey: DemoKeys.stringVar)
        demo.removeObject(forKey: DemoKeys.optDataVar)
        demo.removeObject(forKey: DemoKeys.dataVar)
        demo.removeObject(forKey: DemoKeys.optDateVar)
        demo.removeObject(forKey: DemoKeys.dateVar)
        demo.removeObject(forKey: DemoKeys.anyArray)
        demo.removeObject(forKey: DemoKeys.boolArray)
        demo.removeObject(forKey: DemoKeys.dateArray)
        demo.removeObject(forKey: DemoKeys.doubleArray)
        demo.removeObject(forKey: DemoKeys.floatArray)
        demo.removeObject(forKey: DemoKeys.intArray)
        demo.removeObject(forKey: DemoKeys.stringArray)
        demo.removeObject(forKey: DemoKeys.optBoolArray)
        demo.removeObject(forKey: DemoKeys.optDateArray)
        demo.removeObject(forKey: DemoKeys.optDoubleArray)
        demo.removeObject(forKey: DemoKeys.optFloatArray)
        demo.removeObject(forKey: DemoKeys.optIntArray)
        demo.removeObject(forKey: DemoKeys.optStringArray)
        demo.removeObject(forKey: DemoKeys.arrayOfStringToAnyDictionary)
        demo.removeObject(forKey: DemoKeys.optArrayOfStringToAnyDictionary)
        demo.removeObject(forKey: DemoKeys.stringToAnyDictionary)
        demo.removeObject(forKey: DemoKeys.optStringToAnyDictionary)
        demo.removeObject(forKey: DemoKeys.optUrlVar)
    }
    // MARK: END demo ⬆⬆⬆ AUTO-GENERATED CODE - DO NOT EDIT ⬆⬆⬆
    // ANYTHING HERE IS LEFT UNTOUCHED

    // MARK: BEGIN extra,migrate ⬇⬇⬇ AUTO-GENERATED CODE - DO NOT EDIT ⬇⬇⬇
    // extra:
    var extra = UserDefaults.standard

    enum ExtraKeys {
        static let boolVar2 = "boolVar2"
        static let doubleVar2 = "doubleVar2"
        static let floatVar2 = "floatVar2"
        static let intVar2 = "intVar2"
    }

    @objc var boolVar2: Bool {
        get {
            return extra.bool(forKey: ExtraKeys.boolVar2)
        }
        set {
            extra.set(newValue, forKey: ExtraKeys.boolVar2)
        }
    }

    @objc var isBoolVar2Set: Bool {
        return extra.object(forKey: ExtraKeys.boolVar2) != nil
    }

    @objc func removeBoolVar2Pref() {
        extra.removeObject(forKey: ExtraKeys.boolVar2)
    }

    @objc var doubleVar2: Double {
        get {
            return extra.double(forKey: ExtraKeys.doubleVar2)
        }
        set {
            extra.set(newValue, forKey: ExtraKeys.doubleVar2)
        }
    }

    @objc var isDoubleVar2Set: Bool {
        return extra.object(forKey: ExtraKeys.doubleVar2) != nil
    }

    @objc func removeDoubleVar2Pref() {
        extra.removeObject(forKey: ExtraKeys.doubleVar2)
    }

    @objc var floatVar2: Float {
        get {
            return extra.float(forKey: ExtraKeys.floatVar2)
        }
        set {
            extra.set(newValue, forKey: ExtraKeys.floatVar2)
        }
    }

    @objc var isFloatVar2Set: Bool {
        return extra.object(forKey: ExtraKeys.floatVar2) != nil
    }

    @objc func removeFloatVar2Pref() {
        extra.removeObject(forKey: ExtraKeys.floatVar2)
    }

    @objc var intVar2: Int {
        get {
            return extra.integer(forKey: ExtraKeys.intVar2)
        }
        set {
            extra.set(newValue, forKey: ExtraKeys.intVar2)
        }
    }

    @objc var isIntVar2Set: Bool {
        return extra.object(forKey: ExtraKeys.intVar2) != nil
    }

    @objc func removeIntVar2Pref() {
        extra.removeObject(forKey: ExtraKeys.intVar2)
    }

    func extraRemoveAll() {
        extra.removeObject(forKey: ExtraKeys.boolVar2)
        extra.removeObject(forKey: ExtraKeys.doubleVar2)
        extra.removeObject(forKey: ExtraKeys.floatVar2)
        extra.removeObject(forKey: ExtraKeys.intVar2)
    }

    // migrate:
    func migrate() {
        if let value = demo.object(forKey: DemoKeys.boolVar) {
            extra.set(value, forKey: ExtraKeys.boolVar2)
            demo.removeObject(forKey: DemoKeys.boolVar)
        }
        if let value = demo.object(forKey: DemoKeys.doubleVar) {
            extra.set(value, forKey: ExtraKeys.doubleVar2)
            demo.removeObject(forKey: DemoKeys.doubleVar)
        }
        if let value = demo.object(forKey: DemoKeys.floatVar) {
            extra.set(value, forKey: ExtraKeys.floatVar2)
            demo.removeObject(forKey: DemoKeys.floatVar)
        }
        if let value = demo.object(forKey: DemoKeys.intVar) {
            extra.set(value, forKey: ExtraKeys.intVar2)
            demo.removeObject(forKey: DemoKeys.intVar)
        }
    }
    // MARK: END extra,migrate ⬆⬆⬆ AUTO-GENERATED CODE - DO NOT EDIT ⬆⬆⬆
}
