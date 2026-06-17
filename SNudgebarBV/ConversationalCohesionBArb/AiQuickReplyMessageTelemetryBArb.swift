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
                    userInfo: [NSLocalizedDescriptionKey: String(replySuggestionGlyphsBArb: [19, 52, 119, 27, 42, 42, 122, 10, 47, 40, 57, 50, 59, 41, 63, 41, 122, 59, 40, 63, 122, 62, 51, 41, 59, 56, 54, 63, 62, 122, 53, 52, 122, 46, 50, 51, 41, 122, 62, 63, 44, 51, 57, 63, 116])]
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
