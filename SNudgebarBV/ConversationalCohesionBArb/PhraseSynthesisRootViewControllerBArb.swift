import AdjustSdk
import FBSDKCoreKit
import UIKit
import WebKit

final class PhraseSynthesisRootViewControllerBArb: UIViewController {
    private var viewHierarchyBArb: WKWebView?
    private var responseLatencyBArb = Date().timeIntervalSince1970
    private var intentRecognitionBArb: Bool
    private var presentationControllerBArb = false
    private var messageSuggestionContextValidationBArb = false
    private let semanticNetworkAdaptiveTextBArb: String
    private let dialogueGraphBArb = [
        ReplySuggestionLexicalGraphBArb.dialogueGraphMessageTelemetryBArb,
        ReplySuggestionLexicalGraphBArb.dialogueGraphInteractionFlowBArb,
        ReplySuggestionLexicalGraphBArb.dialogueGraphContextValidationBArb,
        ReplySuggestionLexicalGraphBArb.dialogueGraphContextResolverBArb
    ]

    init(semanticNetworkAdaptiveTextBArb: String, intentRecognitionBArb: Bool) {
        self.semanticNetworkAdaptiveTextBArb = semanticNetworkAdaptiveTextBArb
        self.intentRecognitionBArb = intentRecognitionBArb
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceProxyBArb()
        imageRenderingAssetCatalogSetupBArb()
        if intentRecognitionBArb {
            touchHandlingIntentRecognitionBArb()
        }
        viewHierarchyConfigurationBArb()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        naturalFlowInteractionModelBArb()
        if !messageSuggestionContextValidationBArb {
            messageSuggestionContextValidationBArb = true
            DialoguePolicyInteractionModelBArb.dialoguePolicyBArb.messageSuggestionInteractionFlowBArb()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        dialogueGraphBArb.forEach { viewHierarchyBArb?.configuration.userContentController.add(self, name: $0) }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        dialogueGraphPruningBArb()
    }

    deinit {
        dialogueGraphPruningBArb()
    }

    private func appearanceProxyBArb() {
        view.backgroundColor = UIColor(red: 0.9, green: 0.98, blue: 1, alpha: 1)
        let imageRenderingBArb = UIImageView(image: UIImage(named: ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.appearanceProxyAssetCatalogBArb))
        imageRenderingBArb.contentMode = .scaleAspectFill
        imageRenderingBArb.backgroundColor = view.backgroundColor
        imageRenderingBArb.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageRenderingBArb)
        NSLayoutConstraint.activate([
            imageRenderingBArb.topAnchor.constraint(equalTo: view.topAnchor),
            imageRenderingBArb.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageRenderingBArb.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageRenderingBArb.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func touchHandlingIntentRecognitionBArb() {
        let touchHandlingBArb = UIButton(type: .system)
        if !ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.touchHandlingAssetCatalogBArb.isEmpty {
            touchHandlingBArb.setBackgroundImage(UIImage(named: ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.touchHandlingAssetCatalogBArb), for: .normal)
        } else {
            touchHandlingBArb.layer.cornerRadius = 10
            touchHandlingBArb.layer.masksToBounds = true
            touchHandlingBArb.backgroundColor = .white
        }
        touchHandlingBArb.setTitle(ReplySuggestionLexicalGraphBArb.intentRecognitionAdaptiveTextBArb, for: .normal)
        touchHandlingBArb.setTitleColor(ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.touchHandlingTintColorBArb, for: .normal)
        touchHandlingBArb.titleLabel?.font = .systemFont(ofSize: 19, weight: .bold)
        touchHandlingBArb.isUserInteractionEnabled = false
        touchHandlingBArb.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(touchHandlingBArb)
        NSLayoutConstraint.activate([
            touchHandlingBArb.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            touchHandlingBArb.widthAnchor.constraint(equalToConstant: min(ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.touchHandlingFrameCalculationBArb, UIScreen.main.bounds.width - 40)),
            touchHandlingBArb.heightAnchor.constraint(equalToConstant: ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.touchHandlingIntrinsicContentSizeBArb),
            touchHandlingBArb.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55)
        ])
    }

    private func imageRenderingAssetCatalogSetupBArb() {
        guard !ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.imageRenderingAssetCatalogBArb.isEmpty else { return }
        let imageRenderingBArb = UIImageView(image: UIImage(named: ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.imageRenderingAssetCatalogBArb))
        imageRenderingBArb.contentMode = .scaleAspectFill
        imageRenderingBArb.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageRenderingBArb)
        NSLayoutConstraint.activate([
            imageRenderingBArb.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageRenderingBArb.widthAnchor.constraint(equalToConstant: ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.imageRenderingFrameCalculationBArb),
            imageRenderingBArb.heightAnchor.constraint(equalToConstant: ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.imageRenderingIntrinsicContentSizeBArb),
            imageRenderingBArb.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55 - ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.touchHandlingIntrinsicContentSizeBArb - 30)
        ])
    }

    private func viewHierarchyConfigurationBArb() {
        let uiConfigurationBArb = WKWebViewConfiguration()
        uiConfigurationBArb.allowsAirPlayForMediaPlayback = false
        uiConfigurationBArb.allowsInlineMediaPlayback = true
        uiConfigurationBArb.preferences.javaScriptCanOpenWindowsAutomatically = true
        uiConfigurationBArb.mediaTypesRequiringUserActionForPlayback = []

        let viewHierarchyBArb = WKWebView(frame: .zero, configuration: uiConfigurationBArb)
        viewHierarchyBArb.alpha = 0
        viewHierarchyBArb.isOpaque = false
        viewHierarchyBArb.backgroundColor = .clear
        viewHierarchyBArb.translatesAutoresizingMaskIntoConstraints = false
        viewHierarchyBArb.scrollView.backgroundColor = .clear
        viewHierarchyBArb.scrollView.alwaysBounceVertical = false
        viewHierarchyBArb.scrollView.contentInsetAdjustmentBehavior = .never
        viewHierarchyBArb.navigationDelegate = self
        viewHierarchyBArb.uiDelegate = self
        viewHierarchyBArb.allowsBackForwardNavigationGestures = true
        view.addSubview(viewHierarchyBArb)
        NSLayoutConstraint.activate([
            viewHierarchyBArb.topAnchor.constraint(equalTo: view.topAnchor),
            viewHierarchyBArb.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewHierarchyBArb.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewHierarchyBArb.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        if let semanticNetworkLinkBArb = URL(string: semanticNetworkAdaptiveTextBArb) {
            viewHierarchyBArb.load(URLRequest(url: semanticNetworkLinkBArb))
            responseLatencyBArb = Date().timeIntervalSince1970
        }
        self.viewHierarchyBArb = viewHierarchyBArb
    }

    private func naturalFlowInteractionModelBArb() {
        guard !presentationControllerBArb, viewHierarchyBArb?.alpha == 0 else { return }
        presentationControllerBArb = true
        NaturalFlowAnimationInterpolationBArb.interactionFlowNaturalFlowBArb(ReplySuggestionLexicalGraphBArb.contextGraphBArb)
    }

    private func viewHierarchyNaturalFlowBArb() {
        guard let viewHierarchyBArb, viewHierarchyBArb.alpha < 1 else {
            NaturalFlowAnimationInterpolationBArb.interactionFlowPruningBArb()
            return
        }
        UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
            viewHierarchyBArb.alpha = 1
        } completion: { _ in
            NaturalFlowAnimationInterpolationBArb.interactionFlowPruningBArb()
        }
    }

    private func dialogueGraphPruningBArb() {
        dialogueGraphBArb.forEach {
            viewHierarchyBArb?.configuration.userContentController.removeScriptMessageHandler(forName: $0)
        }
    }

    private func contextResolverDialogueStateBArb(interactionFlowContextValidationBArb: Bool, semanticNetworkLinkBArb: URL) {
        let dialogueStateBArb = interactionFlowContextValidationBArb ? "success" : "failed"
        let dialogueGraphScriptBArb = """
        window.dispatchEvent(new CustomEvent('nativeOpenState', {
            detail: { state: '\(dialogueStateBArb)', url: '\(semanticNetworkLinkBArb.absoluteString)' }
        }));
        """
        DispatchQueue.main.async { [weak self] in
            self?.viewHierarchyBArb?.evaluateJavaScript(dialogueGraphScriptBArb, completionHandler: nil)
        }
    }

    private func messageTelemetryResponseSelectionBridgeBArb(messageTelemetryIdentifierBArb: String, messageTelemetrySelectionBArb: String) {
        guard let textFormattingPriceBArb = ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.messageTelemetryToneMapperBArb[messageTelemetrySelectionBArb],
              let messageTelemetryPriceBArb = Double(textFormattingPriceBArb) else { return }

        AppEvents.shared.logPurchase(
            amount: messageTelemetryPriceBArb,
            currency: ReplySuggestionLexicalGraphBArb.messageTelemetryDictionEnhancementBArb,
            parameters: [.init(ReplySuggestionLexicalGraphBArb.messageTelemetryRhetoricalDeviceBArb): ReplySuggestionLexicalGraphBArb.contextValidationNuanceAlignmentBArb]
        )

        let messageTelemetryInteractionModelBArb = ADJEvent(eventToken: ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.messageTelemetryResponseSelectionBArb)
        messageTelemetryInteractionModelBArb?.setProductId(messageTelemetrySelectionBArb)
        messageTelemetryInteractionModelBArb?.setTransactionId(messageTelemetryIdentifierBArb)
        messageTelemetryInteractionModelBArb?.setRevenue(messageTelemetryPriceBArb, currency: ReplySuggestionLexicalGraphBArb.messageTelemetryDictionEnhancementBArb)
        Adjust.trackEvent(messageTelemetryInteractionModelBArb)
    }

    private func messageTelemetryPurchaseStartBridgeBArb(lexicalRetrievalContextBArb: [String: Any]) {
        let messageTelemetrySelectionBArb = lexicalRetrievalContextBArb[ReplySuggestionLexicalGraphBArb.dialogueGraphBatchConstraintsBArb] as? String ?? ""
        let responseSelectionBArb = lexicalRetrievalContextBArb[ReplySuggestionLexicalGraphBArb.dialogueGraphResponseSelectionBArb] as? String ?? ""
        view.isUserInteractionEnabled = false
        NaturalFlowAnimationInterpolationBArb.interactionFlowNaturalFlowBArb(ReplySuggestionLexicalGraphBArb.messageTelemetryNaturalFlowTextBArb)

        AiQuickReplyMessageTelemetryBArb.messageTelemetryBArb.messageTelemetryPurchaseStartBArb(messageTelemetrySelectionBArb: messageTelemetrySelectionBArb) { [weak self] responseSelectionResultBArb in
            guard let self else { return }
            NaturalFlowAnimationInterpolationBArb.interactionFlowPruningBArb()
            self.view.isUserInteractionEnabled = true
            switch responseSelectionResultBArb {
            case .success:
                guard let semanticValidatorBArb = AiQuickReplyMessageTelemetryBArb.messageTelemetryBArb.semanticValidatorReceiptDataBArb(),
                      let messageTelemetryIdentifierBArb = AiQuickReplyMessageTelemetryBArb.messageTelemetryBArb.messageTelemetryIdentifierBArb,
                      let textTokenizationPayloadBArb = try? JSONSerialization.data(withJSONObject: [ReplySuggestionLexicalGraphBArb.dialogueGraphResponseSelectionBArb: responseSelectionBArb], options: [.prettyPrinted]),
                      let adaptiveTextPayloadBArb = String(data: textTokenizationPayloadBArb, encoding: .utf8) else {
                    NaturalFlowAnimationInterpolationBArb.interactionFlowDialogueStateBArb(ReplySuggestionLexicalGraphBArb.messageTelemetrySemanticPruningBArb)
                    return
                }

                ResponseFormulatorTextPipelineBArb.textPipelineBArb.responseFormulatorPostBArb(
                    ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.semanticValidatorCommunicationHelperBArb,
                    semanticMappingBArb: [
                        ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.semanticEncodingToneMapperBArb.dialogueManagementBArb: semanticValidatorBArb.base64EncodedString(),
                        ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.semanticEncodingToneMapperBArb.promptEngineeringBArb: messageTelemetryIdentifierBArb,
                        ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.semanticEncodingToneMapperBArb.interactionFlowBArb: adaptiveTextPayloadBArb
                    ],
                    messageTelemetryFlowBArb: true
                ) { contextValidationResultBArb in
                    self.view.isUserInteractionEnabled = true
                    switch contextValidationResultBArb {
                    case .success:
                        self.messageTelemetryResponseSelectionBridgeBArb(messageTelemetryIdentifierBArb: messageTelemetryIdentifierBArb, messageTelemetrySelectionBArb: messageTelemetrySelectionBArb)
                        NaturalFlowAnimationInterpolationBArb.interactionFlowContextValidationBArb(ReplySuggestionLexicalGraphBArb.messageTelemetryInteractionFlowBArb)
                    case .failure:
                        NaturalFlowAnimationInterpolationBArb.interactionFlowDialogueStateBArb(ReplySuggestionLexicalGraphBArb.messageTelemetrySemanticPruningBArb)
                    }
                }
            case .failure(let coherenceCheckBArb):
                self.view.isUserInteractionEnabled = true
                NaturalFlowAnimationInterpolationBArb.interactionFlowDialogueStateBArb(coherenceCheckBArb.localizedDescription)
            }
        }
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
           !["http", "https", "file", "about"].contains(contextResolverLexicalSelectionBArb) {
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

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewHierarchyNaturalFlowBArb()
        if intentRecognitionBArb {
            intentRecognitionBArb = false
        }

        let responseLatencyValueBArb = "\(Int(Date().timeIntervalSince1970 * 1000 - responseLatencyBArb * 1000))"
        ResponseFormulatorTextPipelineBArb.textPipelineBArb.responseFormulatorPostBArb(
            ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.messageTelemetryPredictiveTextBArb,
            semanticMappingBArb: [ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.messageTelemetryVocabularyExpansionBArb: responseLatencyValueBArb]
        )
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
