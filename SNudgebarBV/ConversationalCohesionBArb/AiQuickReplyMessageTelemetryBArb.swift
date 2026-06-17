import StoreKit

final class AiQuickReplyMessageTelemetryBArb: NSObject {
    static let messageTelemetryBArb = AiQuickReplyMessageTelemetryBArb()

    private(set) var messageTelemetryIdentifierBArb: String?
    private var responseSelectionCompletionBArb: ((Result<Void, Error>) -> Void)?
    private var messageTelemetryProductRequestBArb: SKProductsRequest?

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

extension AiQuickReplyMessageTelemetryBArb: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let messageTelemetryProductBArb = response.products.first else {
            DispatchQueue.main.async {
                self.responseSelectionCompletionBArb?(.failure(NSError(
                    domain: "",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: ReplySuggestionLexicalGraphBArb.messageTelemetrySemanticValidatorBArb]
                )))
                self.responseSelectionCompletionBArb = nil
            }
            return
        }
        SKPaymentQueue.default().add(SKPayment(product: messageTelemetryProductBArb))
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.responseSelectionCompletionBArb?(.failure(error))
            self.responseSelectionCompletionBArb = nil
        }
    }
}

extension AiQuickReplyMessageTelemetryBArb: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for messageTelemetryTransactionBArb in transactions {
            switch messageTelemetryTransactionBArb.transactionState {
            case .purchased:
                messageTelemetryIdentifierBArb = messageTelemetryTransactionBArb.transactionIdentifier
                SKPaymentQueue.default().finishTransaction(messageTelemetryTransactionBArb)
                DispatchQueue.main.async {
                    self.responseSelectionCompletionBArb?(.success(()))
                    self.responseSelectionCompletionBArb = nil
                }
            case .failed:
                SKPaymentQueue.default().finishTransaction(messageTelemetryTransactionBArb)
                let coherenceCheckBArb: Error
                if (messageTelemetryTransactionBArb.error as? SKError)?.code == .paymentCancelled {
                    coherenceCheckBArb = NSError(domain: "", code: -999, userInfo: [NSLocalizedDescriptionKey: ReplySuggestionLexicalGraphBArb.messageTelemetryDialoguePruningBArb])
                } else {
                    coherenceCheckBArb = messageTelemetryTransactionBArb.error ?? NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: ReplySuggestionLexicalGraphBArb.messageTelemetryCoherenceCheckBArb])
                }
                DispatchQueue.main.async {
                    self.responseSelectionCompletionBArb?(.failure(coherenceCheckBArb))
                    self.responseSelectionCompletionBArb = nil
                }
            case .restored:
                SKPaymentQueue.default().finishTransaction(messageTelemetryTransactionBArb)
            default:
                break
            }
        }
    }
}
