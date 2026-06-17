import StoreKit

extension AiQuickReplyMessageTelemetryBArb: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let messageTelemetryProductBArb = response.products.first else {
            DispatchQueue.main.async {
                self.responseSelectionCompletionBArb?(.failure(NSError(
                    domain: "",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: String(replySuggestionGlyphsBArb: [20, 53, 122, 44, 59, 54, 51, 62, 122, 42, 40, 53, 62, 47, 57, 46, 122, 60, 53, 47, 52, 62, 116])]
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
                    coherenceCheckBArb = NSError(domain: "", code: -999, userInfo: [NSLocalizedDescriptionKey: String(replySuggestionGlyphsBArb: [10, 59, 35, 55, 63, 52, 46, 122, 57, 59, 52, 57, 63, 54, 54, 63, 62])])
                } else {
                    coherenceCheckBArb = messageTelemetryTransactionBArb.error ?? NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: String(replySuggestionGlyphsBArb: [14, 40, 59, 52, 41, 59, 57, 46, 51, 53, 52, 122, 60, 59, 51, 54, 63, 62, 116])])
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
