//
//  Bundle++.swift
//  MusicImport
//
//  Created by Daniil on 07.03.2020.
//  Copyright © 2020 Данил Войдилов. All rights reserved.
//

import Foundation

extension Bundle {
    public var displayName: String? {
     object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
        object(forInfoDictionaryKey: "CFBundleName") as? String ??
        object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
    }
    public var appName: String { (infoDictionary?["CFBundleName"] as? String) ?? "" }
    public var versionNumber: String { (infoDictionary?["CFBundleShortVersionString"] as? String) ?? "" }
    public var buildNumber: String { (infoDictionary?["CFBundleVersion"] as? String) ?? "" }
}
