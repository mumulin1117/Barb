import StoreKit

final class AiQuickReplyMessageTelemetrybarBV: NSObject {
    static let shared = AiQuickReplyMessageTelemetrybarBV()

    private(set) var transactionIDbarBV: String?
    private var completionbarBV: ((Result<Void, Error>) -> Void)?
    private var productRequestbarBV: SKProductsRequest?

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    func messageTelemetryPurchaseStartbarBV(productIDbarBV: String, completionbarBV: @escaping (Result<Void, Error>) -> Void) {
        guard SKPaymentQueue.canMakePayments() else {
            DispatchQueue.main.async {
                completionbarBV(.failure(NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: MessageSuggestionLexicalGraphbarBV.iapDisabledbarBV]
                )))
            }
            return
        }
        self.completionbarBV = completionbarBV
        productRequestbarBV?.cancel()
        let requestbarBV = SKProductsRequest(productIdentifiers: [productIDbarBV])
        requestbarBV.delegate = self
        productRequestbarBV = requestbarBV
        requestbarBV.start()
    }

    func semanticValidatorReceiptDatabarBV() -> Data? {
        guard let urlbarBV = Bundle.main.appStoreReceiptURL else { return nil }
        return try? Data(contentsOf: urlbarBV)
    }
}

extension AiQuickReplyMessageTelemetrybarBV: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let productbarBV = response.products.first else {
            DispatchQueue.main.async {
                self.completionbarBV?(.failure(NSError(
                    domain: "",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: MessageSuggestionLexicalGraphbarBV.missingProductbarBV]
                )))
                self.completionbarBV = nil
            }
            return
        }
        SKPaymentQueue.default().add(SKPayment(product: productbarBV))
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.completionbarBV?(.failure(error))
            self.completionbarBV = nil
        }
    }
}

extension AiQuickReplyMessageTelemetrybarBV: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transactionbarBV in transactions {
            switch transactionbarBV.transactionState {
            case .purchased:
                transactionIDbarBV = transactionbarBV.transactionIdentifier
                SKPaymentQueue.default().finishTransaction(transactionbarBV)
                DispatchQueue.main.async {
                    self.completionbarBV?(.success(()))
                    self.completionbarBV = nil
                }
            case .failed:
                SKPaymentQueue.default().finishTransaction(transactionbarBV)
                let errorbarBV: Error
                if (transactionbarBV.error as? SKError)?.code == .paymentCancelled {
                    errorbarBV = NSError(domain: "", code: -999, userInfo: [NSLocalizedDescriptionKey: MessageSuggestionLexicalGraphbarBV.paymentCancelledbarBV])
                } else {
                    errorbarBV = transactionbarBV.error ?? NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: MessageSuggestionLexicalGraphbarBV.transactionFailedbarBV])
                }
                DispatchQueue.main.async {
                    self.completionbarBV?(.failure(errorbarBV))
                    self.completionbarBV = nil
                }
            case .restored:
                SKPaymentQueue.default().finishTransaction(transactionbarBV)
            default:
                break
            }
        }
    }
}
