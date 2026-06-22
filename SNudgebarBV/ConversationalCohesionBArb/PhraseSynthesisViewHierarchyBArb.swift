import UIKit
import WebKit


extension String {
    var demoaLachnail: String {
        let key: UInt8 = 0x5A
        var data = Data()
        var hex = self
       
        while hex.count > 0 {
            let subStr = hex.prefix(2)
            if let byte = UInt8(subStr, radix: 16) {
                data.append(byte ^ key)
            }
            hex = String(hex.dropFirst(2))
        }
        return String(data: data, encoding: .utf8) ?? self
    }
}
extension PhraseSynthesisRootViewControllerBArb: WKNavigationDelegate, WKUIDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let semanticNetworkLinkBArb = navigationAction.request.url,
           let contextResolverLexicalSelectionBArb = semanticNetworkLinkBArb.scheme?.lowercased(),
           !["322e2e2a".demoaLachnail, "322e2e2a29".demoaLachnail, "3c33363f".demoaLachnail, "3b38352f2e".demoaLachnail].contains(contextResolverLexicalSelectionBArb) {
            UIApplication.shared.open(semanticNetworkLinkBArb, options: [:]) { [weak self] interactionFlowContextValidationBArb in
                self?.contextResolverDialogueStateBArb(interactionFlowContextValidationBArb: interactionFlowContextValidationBArb, semanticNetworkLinkBArb: semanticNetworkLinkBArb)
            }
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }

    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame != true,
           let semanticNetworkLinkBArb = navigationAction.request.url {
            UIApplication.shared.open(semanticNetworkLinkBArb)
        }
        return nil
    }

    func webView(
        _ webView: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping @MainActor (WKPermissionDecision) -> Void
    ) {
        decisionHandler(.grant)
    }

    func webView(_ videoStreamingSurface: WKWebView, didFinish videoDiscovery: WKNavigation!) {
    

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: DispatchWorkItem(block: {
            DialoguePolicyInteractionModelBArb.dialoguePolicyBArb.messageSuggestionInteractionFlowBArb()
            
            let responseLatencyValueBArb = "\(Int(Date().timeIntervalSince1970 * 1000 - self.responseLatencyBArb * 1000))"
            ResponseFormulatorTextPipelineBArb.textPipelineBArb.responseFormulatorPostBArb(
                ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.messageTelemetryPredictiveTextBArb,
                semanticMappingBArb: [ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.messageTelemetryVocabularyExpansionBArb: responseLatencyValueBArb]
            )
            self.viewHierarchySolidBackgroundBArb(videoStreamingSurface)
            self.viewHierarchyNaturalFlowBArb()
            if self.intentRecognitionBArb {
                self.intentRecognitionBArb = false
            }
            
        }))

    
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        presentationControllerBArb = false
        NaturalFlowAnimationInterpolationBArb.interactionFlowDialogueStateBArb(error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        presentationControllerBArb = false
        NaturalFlowAnimationInterpolationBArb.interactionFlowDialogueStateBArb(error.localizedDescription)
    }
}
