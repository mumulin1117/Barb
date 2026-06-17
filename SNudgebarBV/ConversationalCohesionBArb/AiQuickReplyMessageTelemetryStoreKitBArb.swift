import StoreKit

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
