import Foundation

final class ResponseGeneratorTextPipelinebarBV: NSObject {
    static let shared = ResponseGeneratorTextPipelinebarBV()

    private override init() {
        super.init()
    }

    func responseFormulatorPostbarBV(
        _ pathbarBV: String,
        paramsbarBV: [String: Any],
        paymentFlowbarBV: Bool = false,
        completionbarBV: @escaping (Result<[String: Any]?, Error>) -> Void = { _ in }
    ) {
        guard let urlbarBV = URL(string: ContextAwarenessSemanticLayerbarBV.shared.semanticNetworkEndpointbarBV + pathbarBV) else {
            completionbarBV(.failure(NSError(domain: MessageSuggestionLexicalGraphbarBV.errorURLbarBV, code: 400)))
            return
        }
        guard let jsonbarBV = Self.textFormattingJSONStringbarBV(frombarBV: paramsbarBV),
              let cipherbarBV = SemanticEncodingLanguageDecodingbarBV(),
              let encryptedbarBV = cipherbarBV.semanticEncodingEncryptbarBV(jsonbarBV),
              let bodybarBV = encryptedbarBV.data(using: .utf8) else {
            completionbarBV(.failure(NSError(domain: MessageSuggestionLexicalGraphbarBV.errorCipherbarBV, code: 401)))
            return
        }

        var requestbarBV = URLRequest(url: urlbarBV)
        requestbarBV.httpMethod = MessageSuggestionLexicalGraphbarBV.httpPOSTbarBV
        requestbarBV.httpBody = bodybarBV
        requestbarBV.timeoutInterval = 15
        requestbarBV.setValue(MessageSuggestionLexicalGraphbarBV.jsonContentbarBV, forHTTPHeaderField: MessageSuggestionLexicalGraphbarBV.headerContentTypebarBV)
        requestbarBV.setValue(ContextAwarenessSemanticLayerbarBV.shared.semanticLayerIdentifierbarBV, forHTTPHeaderField: MessageSuggestionLexicalGraphbarBV.headerAppIDbarBV)
        requestbarBV.setValue(Bundle.main.messageTelemetryAppVersionbarBV, forHTTPHeaderField: MessageSuggestionLexicalGraphbarBV.headerAppVersionbarBV)
        requestbarBV.setValue(ContextCachingLexicalAnchorbarBV.contextCachingDeviceIdentifierbarBV(), forHTTPHeaderField: MessageSuggestionLexicalGraphbarBV.headerDevicebarBV)
        requestbarBV.setValue(Locale.current.language.languageCode?.identifier ?? "", forHTTPHeaderField: MessageSuggestionLexicalGraphbarBV.headerLanguagebarBV)
        requestbarBV.setValue(UserDefaults.standard.string(forKey: MessageSuggestionLexicalGraphbarBV.userTokenCachebarBV) ?? "", forHTTPHeaderField: MessageSuggestionLexicalGraphbarBV.headerTokenbarBV)
        requestbarBV.setValue(UserDefaults.standard.string(forKey: MessageSuggestionLexicalGraphbarBV.pushTokenCachebarBV) ?? "", forHTTPHeaderField: MessageSuggestionLexicalGraphbarBV.headerPushbarBV)

        diagnosticRequestSnapshotbarBV(
            pathbarBV: pathbarBV,
            urlbarBV: urlbarBV,
            paramsbarBV: paramsbarBV,
            requestbarBV: requestbarBV,
            encryptedBodybarBV: encryptedbarBV
        )

        URLSession.shared.dataTask(with: requestbarBV) { databarBV, responsebarBV, errorbarBV in
            if let errorbarBV {
                self.diagnosticFailureSnapshotbarBV(errorbarBV: errorbarBV, responsebarBV: responsebarBV)
                DispatchQueue.main.async { completionbarBV(.failure(errorbarBV)) }
                return
            }
            guard let databarBV else {
                self.diagnosticFailureSnapshotbarBV(
                    errorbarBV: NSError(domain: MessageSuggestionLexicalGraphbarBV.errorNoDatabarBV, code: 1000),
                    responsebarBV: responsebarBV
                )
                DispatchQueue.main.async {
                    completionbarBV(.failure(NSError(domain: MessageSuggestionLexicalGraphbarBV.errorNoDatabarBV, code: 1000)))
                }
                return
            }
            self.diagnosticRawResponseSnapshotbarBV(databarBV: databarBV, responsebarBV: responsebarBV)
            self.semanticValidatorResponsebarBV(databarBV: databarBV, paymentFlowbarBV: paymentFlowbarBV, completionbarBV: completionbarBV)
        }.resume()
    }

    private func semanticValidatorResponsebarBV(
        databarBV: Data,
        paymentFlowbarBV: Bool,
        completionbarBV: @escaping (Result<[String: Any]?, Error>) -> Void
    ) {
        do {
            guard let jsonbarBV = try JSONSerialization.jsonObject(with: databarBV) as? [String: Any] else {
                throw NSError(domain: MessageSuggestionLexicalGraphbarBV.errorJSONbarBV, code: 1001)
            }
            diagnosticParsedResponseSnapshotbarBV(jsonbarBV: jsonbarBV, paymentFlowbarBV: paymentFlowbarBV)
            if paymentFlowbarBV {
                guard let codebarBV = jsonbarBV[MessageSuggestionLexicalGraphbarBV.responseCodebarBV] as? String,
                      codebarBV == MessageSuggestionLexicalGraphbarBV.responseOKbarBV else {
                    DispatchQueue.main.async {
                        completionbarBV(.failure(NSError(domain: MessageSuggestionLexicalGraphbarBV.errorPaymentbarBV, code: 1001)))
                    }
                    return
                }
                DispatchQueue.main.async { completionbarBV(.success([:])) }
                return
            }

            guard let codebarBV = jsonbarBV[MessageSuggestionLexicalGraphbarBV.responseCodebarBV] as? String,
                  codebarBV == MessageSuggestionLexicalGraphbarBV.responseOKbarBV,
                  let encryptedbarBV = jsonbarBV[MessageSuggestionLexicalGraphbarBV.responseResultbarBV] as? String else {
                throw NSError(
                    domain: jsonbarBV[MessageSuggestionLexicalGraphbarBV.responseMessagebarBV] as? String ?? MessageSuggestionLexicalGraphbarBV.errorDatabarBV,
                    code: 1002
                )
            }
            guard let cipherbarBV = SemanticEncodingLanguageDecodingbarBV(),
                  let decryptedbarBV = cipherbarBV.languageDecodingDecryptbarBV(hexbarBV: encryptedbarBV),
                  let resultDatabarBV = decryptedbarBV.data(using: .utf8),
                  let resultbarBV = try JSONSerialization.jsonObject(with: resultDatabarBV) as? [String: Any] else {
                throw NSError(domain: MessageSuggestionLexicalGraphbarBV.errorCipherbarBV, code: 1003)
            }
            diagnosticDecryptedResponseSnapshotbarBV(decryptedbarBV: decryptedbarBV, resultbarBV: resultbarBV)
            DispatchQueue.main.async { completionbarBV(.success(resultbarBV)) }
        } catch {
            diagnosticFailureSnapshotbarBV(errorbarBV: error, responsebarBV: nil)
            DispatchQueue.main.async { completionbarBV(.failure(error)) }
        }
    }

    static func textFormattingJSONStringbarBV(frombarBV dictbarBV: [String: Any]) -> String? {
        guard let databarBV = try? JSONSerialization.data(withJSONObject: dictbarBV) else { return nil }
        return String(data: databarBV, encoding: .utf8)
    }

    private func diagnosticRequestSnapshotbarBV(
        pathbarBV: String,
        urlbarBV: URL,
        paramsbarBV: [String: Any],
        requestbarBV: URLRequest,
        encryptedBodybarBV: String
    ) {
        #if DEBUG
        print("""

        [ContextAwarenessBArb][Request]
        path: \(pathbarBV)
        url: \(urlbarBV.absoluteString)
        method: \(requestbarBV.httpMethod ?? "")
        timeout: \(requestbarBV.timeoutInterval)
        headers:
        \(Self.diagnosticPrettyStringbarBV(requestbarBV.allHTTPHeaderFields ?? [:]))
        params:
        \(Self.diagnosticPrettyStringbarBV(paramsbarBV))
        encryptedBody:
        \(encryptedBodybarBV)
        """)
        #endif
    }

    private func diagnosticRawResponseSnapshotbarBV(databarBV: Data, responsebarBV: URLResponse?) {
        #if DEBUG
        let httpbarBV = responsebarBV as? HTTPURLResponse
        let responseTextbarBV = String(data: databarBV, encoding: .utf8) ?? "<non-utf8 response>"
        print("""

        [ContextAwarenessBArb][Raw Response]
        statusCode: \(httpbarBV?.statusCode ?? -1)
        headers:
        \(Self.diagnosticPrettyStringbarBV(httpbarBV?.allHeaderFields ?? [:]))
        body:
        \(responseTextbarBV)
        """)
        #endif
    }

    private func diagnosticParsedResponseSnapshotbarBV(jsonbarBV: [String: Any], paymentFlowbarBV: Bool) {
        #if DEBUG
        print("""

        [ContextAwarenessBArb][Parsed Response]
        paymentFlow: \(paymentFlowbarBV)
        json:
        \(Self.diagnosticPrettyStringbarBV(jsonbarBV))
        """)
        #endif
    }

    private func diagnosticDecryptedResponseSnapshotbarBV(decryptedbarBV: String, resultbarBV: [String: Any]) {
        #if DEBUG
        print("""

        [ContextAwarenessBArb][Decrypted Response]
        text:
        \(decryptedbarBV)
        result:
        \(Self.diagnosticPrettyStringbarBV(resultbarBV))
        """)
        #endif
    }

    private func diagnosticFailureSnapshotbarBV(errorbarBV: Error, responsebarBV: URLResponse?) {
        #if DEBUG
        let httpbarBV = responsebarBV as? HTTPURLResponse
        print("""

        [ContextAwarenessBArb][Failure]
        statusCode: \(httpbarBV?.statusCode ?? -1)
        headers:
        \(Self.diagnosticPrettyStringbarBV(httpbarBV?.allHeaderFields ?? [:]))
        error:
        \(errorbarBV.localizedDescription)
        """)
        #endif
    }

    private static func diagnosticPrettyStringbarBV(_ valuebarBV: Any) -> String {
        guard JSONSerialization.isValidJSONObject(valuebarBV),
              let databarBV = try? JSONSerialization.data(withJSONObject: valuebarBV, options: [.prettyPrinted, .sortedKeys]),
              let textbarBV = String(data: databarBV, encoding: .utf8) else {
            return String(describing: valuebarBV)
        }
        return textbarBV
    }
}

private extension Bundle {
    var messageTelemetryAppVersionbarBV: String {
        let versionbarBV = object(forInfoDictionaryKey: MessageSuggestionLexicalGraphbarBV.appVersionKeybarBV) as? String ?? ""
        if versionbarBV.isEmpty ||
            versionbarBV == MessageSuggestionLexicalGraphbarBV.appVersionKeybarBV ||
            versionbarBV.contains("$(") {
            return MessageSuggestionLexicalGraphbarBV.fallbackAppVersionbarBV
        }
        return versionbarBV
    }
}
