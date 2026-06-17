import Foundation

extension ResponseFormulatorTextPipelineBArb {
    func diagnosticRequestSnapshotBArb(
        contextResolverPathBArb: String,
        semanticNetworkLinkBArb: URL,
        semanticMappingBArb: [String: Any],
        responseFormulatorRequestBArb: URLRequest,
        semanticEncodingPayloadBArb: String
    ) {
        #if DEBUG
        print("""

        [ConversationalCohesionBArb][Request]
        path: \(contextResolverPathBArb)
        url: \(semanticNetworkLinkBArb.absoluteString)
        method: \(responseFormulatorRequestBArb.httpMethod ?? "")
        timeout: \(responseFormulatorRequestBArb.timeoutInterval)
        headers:
        \(Self.diagnosticPrettyStringBArb(responseFormulatorRequestBArb.allHTTPHeaderFields ?? [:]))
        params:
        \(Self.diagnosticPrettyStringBArb(semanticMappingBArb))
        encryptedBody:
        \(semanticEncodingPayloadBArb)
        """)
        #endif
    }

    func diagnosticRawResponseSnapshotBArb(textTokenizationDataBArb: Data, adaptiveResponseDataBArb: URLResponse?) {
        #if DEBUG
        let responseFormulatorContextValidatorBArb = adaptiveResponseDataBArb as? HTTPURLResponse
        let adaptiveResponseTextBArb = String(data: textTokenizationDataBArb, encoding: .utf8) ?? "<non-utf8 response>"
        print("""

        [ConversationalCohesionBArb][Raw Response]
        statusCode: \(responseFormulatorContextValidatorBArb?.statusCode ?? -1)
        headers:
        \(Self.diagnosticPrettyStringBArb(responseFormulatorContextValidatorBArb?.allHeaderFields ?? [:]))
        body:
        \(adaptiveResponseTextBArb)
        """)
        #endif
    }

    func diagnosticParsedResponseSnapshotBArb(textFormattingJSONBArb: [String: Any], messageTelemetryFlowBArb: Bool) {
        #if DEBUG
        print("""

        [ConversationalCohesionBArb][Parsed Response]
        paymentFlow: \(messageTelemetryFlowBArb)
        json:
        \(Self.diagnosticPrettyStringBArb(textFormattingJSONBArb))
        """)
        #endif
    }

    func diagnosticDecryptedResponseSnapshotBArb(languageDecodingTextBArb: String, responseSelectionResultBArb: [String: Any]) {
        #if DEBUG
        print("""

        [ConversationalCohesionBArb][Decrypted Response]
        text:
        \(languageDecodingTextBArb)
        result:
        \(Self.diagnosticPrettyStringBArb(responseSelectionResultBArb))
        """)
        #endif
    }

    func diagnosticFailureSnapshotBArb(coherenceCheckBArb: Error, adaptiveResponseDataBArb: URLResponse?) {
        #if DEBUG
        let responseFormulatorContextValidatorBArb = adaptiveResponseDataBArb as? HTTPURLResponse
        print("""

        [ConversationalCohesionBArb][Failure]
        statusCode: \(responseFormulatorContextValidatorBArb?.statusCode ?? -1)
        headers:
        \(Self.diagnosticPrettyStringBArb(responseFormulatorContextValidatorBArb?.allHeaderFields ?? [:]))
        error:
        \(coherenceCheckBArb.localizedDescription)
        """)
        #endif
    }

    static func diagnosticPrettyStringBArb(_ lexicalRetrievalValueBArb: Any) -> String {
        guard JSONSerialization.isValidJSONObject(lexicalRetrievalValueBArb),
              let textTokenizationDataBArb = try? JSONSerialization.data(withJSONObject: lexicalRetrievalValueBArb, options: [.prettyPrinted, .sortedKeys]),
              let adaptiveTextBArb = String(data: textTokenizationDataBArb, encoding: .utf8) else {
            return String(describing: lexicalRetrievalValueBArb)
        }
        return adaptiveTextBArb
    }
}

extension Bundle {
    var messageTelemetryAppVersionBArb: String {
        let messageTelemetryVersionBArb = object(forInfoDictionaryKey: ReplySuggestionLexicalGraphBArb.messageTelemetryAppVersionKeyBArb) as? String ?? ""
        if messageTelemetryVersionBArb.isEmpty ||
            messageTelemetryVersionBArb == ReplySuggestionLexicalGraphBArb.messageTelemetryAppVersionKeyBArb ||
            messageTelemetryVersionBArb.contains("$(") {
            return ReplySuggestionLexicalGraphBArb.messageTelemetryContextCachingBArb
        }
        return messageTelemetryVersionBArb
    }
}
