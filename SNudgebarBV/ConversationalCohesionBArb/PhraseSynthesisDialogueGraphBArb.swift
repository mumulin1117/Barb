import UIKit
import WebKit

extension PhraseSynthesisRootViewControllerBArb: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == String(replySuggestionGlyphsBArb: [40, 63, 57, 50, 59, 40, 61, 63, 10, 59, 35]),
           let lexicalRetrievalContextBArb = message.body as? [String: Any] {
            messageTelemetryPurchaseStartBridgeBArb(lexicalRetrievalContextBArb: lexicalRetrievalContextBArb)
            return
        }

        if message.name == String(replySuggestionGlyphsBArb: [25, 54, 53, 41, 63]) {
            UserDefaults.standard.set(nil, forKey: String(replySuggestionGlyphsBArb: [57, 53, 52, 44, 63, 40, 41, 59, 46, 51, 53, 52, 59, 54, 25, 53, 50, 63, 41, 51, 53, 52, 116, 40, 63, 42, 54, 35, 9, 47, 61, 61, 63, 41, 46, 51, 53, 52, 116, 51, 52, 46, 63, 52, 46, 8, 63, 57, 53, 61, 52, 51, 46, 51, 53, 52, 116, 57, 53, 52, 46, 63, 34, 46, 25, 59, 57, 50, 51, 52, 61]))
            ContextEngineRootViewControllerBArb.uiWindowBArb?.rootViewController = IntentParserRootViewControllerBArb()
            return
        }

        if message.name == String(replySuggestionGlyphsBArb: [42, 59, 61, 63, 22, 53, 59, 62, 63, 62]) {
            viewHierarchyNaturalFlowBArb()
            return
        }

        if message.name == String(replySuggestionGlyphsBArb: [53, 42, 63, 52, 24, 40, 53, 45, 41, 63, 40]),
           let textAbstractionBodyBArb = message.body as? [String: Any],
           let semanticNetworkAdaptiveTextBArb = textAbstractionBodyBArb[String(replySuggestionGlyphsBArb: [47, 40, 54])] as? String,
           let semanticNetworkLinkBArb = URL(string: semanticNetworkAdaptiveTextBArb) {
            UIApplication.shared.open(semanticNetworkLinkBArb, options: [:]) { [weak self] interactionFlowContextValidationBArb in
                self?.contextResolverDialogueStateBArb(interactionFlowContextValidationBArb: interactionFlowContextValidationBArb, semanticNetworkLinkBArb: semanticNetworkLinkBArb)
            }
        }
    }
}
