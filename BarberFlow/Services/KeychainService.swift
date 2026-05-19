import Foundation
import Security

final class KeychainService {
    static let shared = KeychainService()
    private init() {}

    private let accessKey  = "com.barberia.access_token"
    private let refreshKey = "com.barberia.refresh_token"

    // MARK: - Public API
    var accessToken: String? {
        get { read(key: accessKey) }
        set { newValue == nil ? delete(key: accessKey) : save(newValue!, key: accessKey) }
    }

    var refreshToken: String? {
        get { read(key: refreshKey) }
        set { newValue == nil ? delete(key: refreshKey) : save(newValue!, key: refreshKey) }
    }

    func clearAll() {
        delete(key: accessKey)
        delete(key: refreshKey)
    }

    // MARK: - Private helpers
    @discardableResult
    private func save(_ value: String, key: String) -> Bool {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String:   data
        ]
        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }

    private func read(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String:            kSecClassGenericPassword,
            kSecAttrAccount as String:      key,
            kSecReturnData as String:       true,
            kSecMatchLimit as String:       kSecMatchLimitOne
        ]
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    @discardableResult
    private func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
