import Security
import UIKit

enum ContextCachingLexicalAnchorbarBV {
    private static var servicebarBV: String {
        (Bundle.main.bundleIdentifier ?? "com.ludgebar.barb") + ".contextAwareness.messageSuggestion.secure"
    }

    private static var deviceAccountbarBV: String {
        servicebarBV + MessageSuggestionLexicalGraphbarBV.keychainDeviceSuffixbarBV
    }

    private static var passwordAccountbarBV: String {
        servicebarBV + MessageSuggestionLexicalGraphbarBV.keychainPasswordSuffixbarBV
    }

    static func contextCachingDeviceIdentifierbarBV() -> String {
        if let savedbarBV = lexicalRetrievalbarBV(accountbarBV: deviceAccountbarBV) {
            return savedbarBV
        }
        let freshbarBV = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        contextCachingArchivebarBV(freshbarBV, accountbarBV: deviceAccountbarBV)
        return freshbarBV
    }

    static func contextCachingPasscodeArchivebarBV(_ passwordbarBV: String) {
        contextCachingArchivebarBV(passwordbarBV, accountbarBV: passwordAccountbarBV)
    }

    static func contextCachingPasscodeRetrievalbarBV() -> String? {
        lexicalRetrievalbarBV(accountbarBV: passwordAccountbarBV)
    }

    private static func lexicalRetrievalbarBV(accountbarBV: String) -> String? {
        let querybarBV: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: servicebarBV,
            kSecAttrAccount as String: accountbarBV,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var resultbarBV: AnyObject?
        let statusbarBV = SecItemCopyMatching(querybarBV as CFDictionary, &resultbarBV)
        guard statusbarBV == errSecSuccess,
              let databarBV = resultbarBV as? Data,
              let valuebarBV = String(data: databarBV, encoding: .utf8) else {
            return nil
        }
        return valuebarBV
    }

    private static func contextCachingArchivebarBV(_ valuebarBV: String, accountbarBV: String) {
        semanticPruningbarBV(accountbarBV: accountbarBV)
        guard let databarBV = valuebarBV.data(using: .utf8) else { return }
        let querybarBV: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: servicebarBV,
            kSecAttrAccount as String: accountbarBV,
            kSecValueData as String: databarBV,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        SecItemAdd(querybarBV as CFDictionary, nil)
    }

    private static func semanticPruningbarBV(accountbarBV: String) {
        let querybarBV: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: servicebarBV,
            kSecAttrAccount as String: accountbarBV
        ]
        SecItemDelete(querybarBV as CFDictionary)
    }
}
