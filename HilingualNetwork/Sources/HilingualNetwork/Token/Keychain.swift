//
//  Keychain.swift
//  HilingualNetwork
//
//  Created by 성현주 on 3/21/26.
//

import Foundation
import Security

@propertyWrapper
public struct Keychain {
    private let key: String
    private let defaultValue: String

    init(key: String, defaultValue: String) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: String {
        get {
            KeychainStorage.load(key: key) ?? defaultValue
        }
        set {
            if newValue.isEmpty {
                KeychainStorage.delete(key: key)
            } else {
                KeychainStorage.save(key: key, value: newValue)
            }
        }
    }
}

enum KeychainStorage {
    static func save(key: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }

        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    static func load(key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }

        return value
    }

    static func delete(key: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]

        SecItemDelete(query as CFDictionary)
    }
}
