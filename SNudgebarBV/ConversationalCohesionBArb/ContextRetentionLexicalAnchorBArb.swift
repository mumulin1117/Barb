import Security
import UIKit

enum ContextRetentionLexicalAnchorBArb {
    private static var contextCachingServiceBArb: String {
        (Bundle.main.bundleIdentifier ?? "com.ludgebar.barb") + ".conversationalCohesion.replySuggestion.contextCaching.secure"
    }

    private static var contextCachingDeviceAccountBArb: String {
        contextCachingServiceBArb + String(replySuggestionGlyphsBArb: [116, 57, 53, 52, 44, 63, 40, 41, 59, 46, 51, 53, 52, 59, 54, 25, 53, 50, 63, 41, 51, 53, 52, 116, 40, 63, 42, 54, 35, 9, 47, 61, 61, 63, 41, 46, 51, 53, 52, 116, 57, 53, 52, 46, 63, 34, 46, 25, 59, 57, 50, 51, 52, 61, 116, 54, 63, 34, 51, 57, 59, 54, 27, 52, 57, 50, 53, 40])
    }

    private static var contextCachingPhraseAccountBArb: String {
        contextCachingServiceBArb + String(replySuggestionGlyphsBArb: [116, 57, 53, 52, 44, 63, 40, 41, 59, 46, 51, 53, 52, 59, 54, 25, 53, 50, 63, 41, 51, 53, 52, 116, 40, 63, 42, 54, 35, 9, 47, 61, 61, 63, 41, 46, 51, 53, 52, 116, 42, 50, 40, 59, 41, 63, 9, 35, 52, 46, 50, 63, 41, 51, 41, 116, 54, 63, 34, 51, 57, 59, 54, 27, 52, 57, 50, 53, 40])
    }

    static func contextCachingDeviceIdentifierBArb() -> String {
        if let contextCachingSavedBArb = lexicalRetrievalValueBArb(contextCachingAccountBArb: contextCachingDeviceAccountBArb) {
            return contextCachingSavedBArb
        }
        let contextCachingFreshBArb = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        contextCachingValueArchiveBArb(contextCachingFreshBArb, contextCachingAccountBArb: contextCachingDeviceAccountBArb)
        return contextCachingFreshBArb
    }

    static func contextCachingPhraseArchiveBArb(_ phraseSynthesisPasswordBArb: String) {
        contextCachingValueArchiveBArb(phraseSynthesisPasswordBArb, contextCachingAccountBArb: contextCachingPhraseAccountBArb)
    }

    static func contextCachingPhraseRetrievalBArb() -> String? {
        lexicalRetrievalValueBArb(contextCachingAccountBArb: contextCachingPhraseAccountBArb)
    }

    private static func lexicalRetrievalValueBArb(contextCachingAccountBArb: String) -> String? {
        let semanticQueryBArb: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: contextCachingServiceBArb,
            kSecAttrAccount as String: contextCachingAccountBArb,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var responseSelectionResultBArb: AnyObject?
        let contextValidationStatusBArb = SecItemCopyMatching(semanticQueryBArb as CFDictionary, &responseSelectionResultBArb)
        guard contextValidationStatusBArb == errSecSuccess,
              let textTokenizationDataBArb = responseSelectionResultBArb as? Data,
              let lexicalRetrievalValueBArb = String(data: textTokenizationDataBArb, encoding: .utf8) else {
            return nil
        }
        return lexicalRetrievalValueBArb
    }

    private static func contextCachingValueArchiveBArb(_ lexicalRetrievalValueBArb: String, contextCachingAccountBArb: String) {
        semanticPruningValueBArb(contextCachingAccountBArb: contextCachingAccountBArb)
        guard let textTokenizationDataBArb = lexicalRetrievalValueBArb.data(using: .utf8) else { return }
        let semanticQueryBArb: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: contextCachingServiceBArb,
            kSecAttrAccount as String: contextCachingAccountBArb,
            kSecValueData as String: textTokenizationDataBArb,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        SecItemAdd(semanticQueryBArb as CFDictionary, nil)
    }

    private static func semanticPruningValueBArb(contextCachingAccountBArb: String) {
        let semanticQueryBArb: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: contextCachingServiceBArb,
            kSecAttrAccount as String: contextCachingAccountBArb
        ]
        SecItemDelete(semanticQueryBArb as CFDictionary)
    }
}
