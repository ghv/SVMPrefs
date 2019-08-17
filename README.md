# SVMPrefs

**Note**: This tool requires Xcode 11 for compilation as it uses some Swift 5.1 language features.

`SVMPrefs` is a command line tool that generates the code to read and write preferences based on the `SVM` data.

The `SVM` name comes from the three main data elements: Store, Variable, and Migrate.

## Why?

A typical way `UserDefaults` is often used is as follows.

```swift
let prefs = UserDefaults.standard
if !prefs.bool(forKey: "firstLaunch") {
    prefs.set(true, forKey: "firstLaunch") {
    showFTUX()
}
```

This kind of on-the-spot use of `UserDefaults` has at least 10 issues:

1. The caller has to know the data source: `UserDefaults.standard`
1. The caller has to reference the key name, twice: `"firstLaunch"`
1. The caller has to know the type: `prefs.bool` and `true`
1. The caller has to know about any conversions: `!` and `true` (did you catch the inverted logic?)
1. All this code, at the point of use, adds noise around the real purpose of the code -- to call `showFTUX()` on first app launch.
1. This code is then repeated in other places for some preferences, thus violating the DRY principle
1. It is not easy to unit test with the above code.
1. There may be many other preferences throughout the code -- most likely without documentation
1. Migrating preferences to a different `UserDefaults` location is not trivial
1. Removing deprecated preferences is easy to leave undone or forgotten

A solution to the above is to define a dedicated class that encapsulates the details of each preference
so that the application logic can focus on using them in a simple and clear way.
With a dedicated class, using a preference can look like this:

```swift
let prefs = AppPrefs()
if prefs.isFirstLaunch {
    prefs.isFirstLaunch = false
    showFTUX()
}
```

SVMPrefs takes this one step further by generating the code to read, write,
migrate and delete preferences based on your SVM specifications.

## Install from local build

**Note**: This tool requires Xcode 11 for compilation as it uses some Swift 5.1 language features.

Run `make install` from the SVMPrefs root directory to build and install the `svmprefs` binary in `/usr/local/bin`.

You can open the project using Xcode 11 by opening the `Package.swift` file or using `xed .` from the command line.

## Command line

The basic command line is as follows: `svmprefs [command] [options] [args]`

| Command                | Description               |
|------------------------|---------------------------|
| `help`                 | Shows help text           |
| `version`              | Shows version information |
| `gen` source_file_name | Processes the given file and generates the code in the SVM data |

You can run `svmprefs gen --help` to get additional details on the `gen` command.

```
> svmprefs gen --help

Usage: svmprefs gen <input> [options]

Processes the given file and generates the code for the contained SVM data

Options:
  -b, --backup            Create a backup copy of the source file (foo.m -> foo.backup.m)
  -d, --debug             Print debug output
  -h, --help              Show help information
  -i, --indent <value>    Set indent width. (Default: 4)
```

## Using in Xcode

You can integrate SVMPrefs in your Xcode project to have it generate the code prior to compiling as well as
highlight any errors in your SVM specifications via a run script.

Add a new "Run Script Phase" that occurs before compilation with something like the following.

```sh
set -e

if which svmprefs >/dev/null; then
  # Update this section with the desired command line options and
  # actual file paths to your code that have SVM data.
  # NOTE: svmprefs supports just one file at a time.
  svmprefs gen -i 4 $SRCROOT/Common/SharedUserDefaults.swift
else
  echo "WARNING: svmprefs is not installed. See: https://github.com/ghv/SVMPrefs"
fi
```

## SVM Data Format

You must add a comment block in your code that starts and ends with `SVMPREFS` like the following.

```swift
/*SVMPREFS [NB: the rest of this line reserved for svmprefs tool use]

# this line is treated as a comment by svmprefs
S demo
V Bool | isDemo | demo_key_name | |

SVMPREFS*/
```

## `#` &mdash; Comment

Any line with a `#` as the first non-white-space character is treated as a comment within the `SVMPREFS` comment block

## `S` &mdash; Store

The store record has three parameters that are `|` delimited

* `name` - A name for this store that is used to define the store's class instance variable and code mark identifier. The name can be anything except `delete` and `migrate`.
* `suite` - An expression that, if specified, is used to construct a store object with a suite name (AKA app group in iOS). See `UserDefaults`. Use `none` to omit generating a store variable as you will supply one in your class. Leave this blank or write `standard` to use `UserDefaults.standard`.
* `options` - A comma-delimited set of code generation flags. (See code below)

```swift
enum Options: String {
    case generateRemoveAllMethod = "RALL"
}
```

You define one `S` record for each unique suite. Each `S` record is followed by any number of `V` records.

## `V` &mdash; Variable

The variable record has five parameters that are `|` delimited

* `type` - Any valid variable type expression including arrays, dates, optionals, and dictionaries.
* `name` - The property name for this preference. If the variable is a boolean type, it will have an `is` prefix prepended if not already prepended.
* `key` - The preference's key name. Leading and trailing white-space characters are not supported.
* `options` - An optional comma-delimited set of code generation flags (See code below)
* `default` - An optional default value to be returned if the preference does not exist in the store or has a null value.

```swift
enum Options: String {
    case generateInvertedLogic = "INV"
    case decorateWithObjC = "OBJC"

    // Defining a Bool named 'firstLaunch' with this option will
    // generate code for it as 'isFirstLaunch' in some places.
    case decorateNameWithIsPrefix = "IS"

    case omitGeneratingGetterAndSetter = "NVAR"
    case omitGeneratingSetter = "NSET"

    case addToRemoveAllMethod = "RALL"
    case omitFromRemoveAllMethod = "NRALL"

    case generateRemovePrefMethod = "REM"
    case generateIsSetMethod = "ISSET"
}
```

### `M` &mdash; Migrate

If you have one or more `S` records, you can use the `M` records to move the preferences from one store to another or delete them as your needs change.

The migrate record has four parameters that are `|` delimited:

* `source store` - The source `S` record's `name`
* `destination store` - The destination `S` record's `name`. Use `delete` if source variable is being deleted.
* `source variable name` - The variable `name` in the source store.
* `destination variable name` - The variable `name` in the destination store. Omit if being deleted.

The tool will insert all the migration code in a function called `migrate()` that you should call every time the app starts.
Migration is performed as an object to object read and write. Once, migrated, the key is deleted from the source store.
You must include a code mark named `migrate` somewhere in your class.

Any variable that is migrated or deleted will no longer be accessible from the source store as a property. However, the key for this property will
remain in the source store's `Keys` enum.

## Generated Code Marks

The generated code must be placed in a class in your source file. Add a pair of comments, as shown below, with the `identifier` being the store's `name`
to indicate where the generated code is to be inserted.

```swift
    // MARK: BEGIN identifier
    // MARK: END identifier
```

If you have any migrations defined, you will also need to include a code mark for the `migrate` `identifier`.

You can specify multiple `identifier`s in the same MARK by joining them together with a comma delimiter in the order you want them to appear.
The begin and end marks must have the same identifiers in identical order. No spaces around the commas or you will get errors.

```swift
    // MARK: BEGIN foo,bar
    // MARK: END foo,bar
```

### Minimal Swift example:

```swift
/*SVMPREFS
S demo
V Bool | isDemo | demo_key_name | |
SVMPREFS*/

class MyDemoPreferences {

    // ANYTHING HERE IS LEFT UNTOUCHED

    // MARK: BEGIN demo
    // ANYTHING HERE WILL BE REPLACED
    // BY THE GENERATED CODE
    // MARK: END demo

    // ANYTHING HERE IS LEFT UNTOUCHED
}
```

# License

SVMPrefs is licensed under the Apache 2.0 License. All contributions are welcome. See [LICENSE.txt](LICENSE.txt) for details.

# Thank You!
