//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//  Documentation
//  https://jessesquires.github.io/Foil
//
//  GitHub
//  https://github.com/jessesquires/Foil
//
//  Copyright © 2021-present Jesse Squires
//

import Foundation

// swiftlint:disable force_cast

extension UserDefaults {
    
    func save<T: Codable>(_ value: T, for key: String) {
        if T.self == URL.self {
            // Hack for URL, which is special
            // See: http://dscoder.com/defaults.html
            // Error: Attempt to insert non-property list object, NSInvalidArgumentException
            set(value as? URL, forKey: key)
            return
        }
        if let savable = value as? UserDefaultsSerializable {
            set(savable.storedValue, forKey: key)
        } else {
            guard let data = try? JSONEncoder().encode(Wrapper(v: value)) else { return }
            set(data, forKey: key)
        }
    }

    func fetch<T: Codable>(_ key: String) -> T? {
        if T.self == URL.self {
            // Hack for URL, which is special
            // See: http://dscoder.com/defaults.html
            // Error: Could not cast value of type '_NSInlineData' to 'NSURL'
            return url(forKey: key) as? T
        }

        if let type = T.self as? UserDefaultsSerializable.Type {
            return value(forKey: key).flatMap { type.init(storedValue: $0) } as? T
        }
        return data(forKey: key).flatMap {
            try? JSONDecoder().decode(Wrapper<T>.self, from: $0).v
        }
    }
}

private struct Wrapper<T: Codable>: Codable {
    var v: T
}
