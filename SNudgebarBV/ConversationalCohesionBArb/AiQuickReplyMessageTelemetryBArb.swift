import StoreKit

final class AiQuickReplyMessageTelemetryBArb: NSObject {
    static let messageTelemetryBArb = AiQuickReplyMessageTelemetryBArb()

    var messageTelemetryIdentifierBArb: String?
    var responseSelectionCompletionBArb: ((Result<Void, Error>) -> Void)?
    var messageTelemetryProductRequestBArb: SKProductsRequest?

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    func messageTelemetryPurchaseStartBArb(messageTelemetrySelectionBArb: String, responseSelectionCompletionBArb: @escaping (Result<Void, Error>) -> Void) {
        guard SKPaymentQueue.canMakePayments() else {
            DispatchQueue.main.async {
                responseSelectionCompletionBArb(.failure(NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: ReplySuggestionLexicalGraphBArb.messageTelemetryContextValidationBArb]
                )))
            }
            return
        }
        self.responseSelectionCompletionBArb = responseSelectionCompletionBArb
        messageTelemetryProductRequestBArb?.cancel()
        let responseFormulatorRequestBArb = SKProductsRequest(productIdentifiers: [messageTelemetrySelectionBArb])
        responseFormulatorRequestBArb.delegate = self
        messageTelemetryProductRequestBArb = responseFormulatorRequestBArb
        responseFormulatorRequestBArb.start()
    }

    func semanticValidatorReceiptDataBArb() -> Data? {
        guard let semanticNetworkLinkBArb = Bundle.main.appStoreReceiptURL else { return nil }
        return try? Data(contentsOf: semanticNetworkLinkBArb)
    }
}
