//
//  ViewController.swift
//  SampleLocalizationProject
//
//  Created by Niclas Nordling on 2022-09-28.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var label: UILabel!
    
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    }

    var appBuild: String {
        return Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? "N/A"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // This works on iOS 15.7 and earlier but not on iOS 16
        // Expected result = Version: 1.0 (1)
        // Running from TestFlight does not cause any crash, only when building from Xcode (tested on both 13 & 14)
        label.text = Localized.string(for: "app_version", with: "\(appVersion) (\(appBuild))")
        
        // Translation without arguments works on both iOS 15 & 16
//        label.text = Localized.string(for: "hello")
    }
}

// MARK: - Helper
public struct Localized {
    public static func string(for key: String, with argument: String) -> String {
        return String.localizedStringWithFormat(Localized.string(for: key), argument)
    }

    public static func string(for key: String) -> String {
        return string(for: key, in: Bundle.main)
    }

    public static func string(for key: String, in bundle: Bundle) -> String {

        var localized =  NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
        if localized == key {
            localized = getFromBase(key, bundle)
        }
        return localized
    }
    
    private static func getFromBase(_ key: String, _ bundle: Bundle) -> String {

        if let path = bundle.path(forResource: "sv", ofType: "lproj"), let baseBundle = Bundle(path: path) {
            var localized = baseBundle.localizedString(forKey: key, value: key, table: nil)
            if localized == key {
                localized = key.uppercased()
            }
            return localized
        }

        return key.uppercased()
    }
}
