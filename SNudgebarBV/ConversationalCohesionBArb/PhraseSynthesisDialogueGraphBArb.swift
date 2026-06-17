import UIKit
import WebKit

extension PhraseSynthesisRootViewControllerBArb: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == ReplySuggestionLexicalGraphBArb.dialogueGraphMessageTelemetryBArb,
           let lexicalRetrievalContextBArb = message.body as? [String: Any] {
            messageTelemetryPurchaseStartBridgeBArb(lexicalRetrievalContextBArb: lexicalRetrievalContextBArb)
            return
        }

        if message.name == ReplySuggestionLexicalGraphBArb.dialogueGraphInteractionFlowBArb {
            UserDefaults.standard.set(nil, forKey: ReplySuggestionLexicalGraphBArb.intentRecognitionContextCachingBArb)
            ContextEngineRootViewControllerBArb.uiWindowBArb?.rootViewController = IntentParserRootViewControllerBArb()
            return
        }

        if message.name == ReplySuggestionLexicalGraphBArb.dialogueGraphContextValidationBArb {
            viewHierarchyNaturalFlowBArb()
            return
        }

        if message.name == ReplySuggestionLexicalGraphBArb.dialogueGraphContextResolverBArb,
           let textAbstractionBodyBArb = message.body as? [String: Any],
           let semanticNetworkAdaptiveTextBArb = textAbstractionBodyBArb[ReplySuggestionLexicalGraphBArb.dialogueGraphSemanticNetworkBArb] as? String,
           let semanticNetworkLinkBArb = URL(string: semanticNetworkAdaptiveTextBArb) {
            UIApplication.shared.open(semanticNetworkLinkBArb, options: [:]) { [weak self] interactionFlowContextValidationBArb in
                self?.contextResolverDialogueStateBArb(interactionFlowContextValidationBArb: interactionFlowContextValidationBArb, semanticNetworkLinkBArb: semanticNetworkLinkBArb)
            }
        }
    }
}
