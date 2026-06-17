import AdjustSdk
import FBSDKCoreKit
import UIKit
import WebKit

final class DialogueSynthesisRootViewControllerbarBV: UIViewController {
    private var webViewbarBV: WKWebView?
    private var pageStartbarBV = Date().timeIntervalSince1970
    private var quickLoginbarBV: Bool
    private var loadingPresentedbarBV = false
    private let urlStringbarBV: String
    private let bridgeNamesbarBV = [
        MessageSuggestionLexicalGraphbarBV.bridgeRechargebarBV,
        MessageSuggestionLexicalGraphbarBV.bridgeClosebarBV,
        MessageSuggestionLexicalGraphbarBV.bridgeLoadedbarBV,
        MessageSuggestionLexicalGraphbarBV.bridgeOpenBrowserbarBV
    ]

    init(urlStringbarBV: String, quickLoginbarBV: Bool) {
        self.urlStringbarBV = urlStringbarBV
        self.quickLoginbarBV = quickLoginbarBV
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceProxyBackgroundbarBV()
        addSmallAssetbarBV()
        if quickLoginbarBV {
            addLockedLoginButtonbarBV()
        }
        configureWebbarBV()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showInitialLoadingIfNeededbarBV()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        bridgeNamesbarBV.forEach { webViewbarBV?.configuration.userContentController.add(self, name: $0) }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        removeBridgebarBV()
    }

    deinit {
        removeBridgebarBV()
    }

    private func appearanceProxyBackgroundbarBV() {
        view.backgroundColor = UIColor(red: 0.9, green: 0.98, blue: 1, alpha: 1)
        let imageViewbarBV = UIImageView(image: UIImage(named: ContextAwarenessSemanticLayerbarBV.shared.appearanceProxyBackgroundAssetbarBV))
        imageViewbarBV.contentMode = .scaleAspectFill
        imageViewbarBV.backgroundColor = view.backgroundColor
        imageViewbarBV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageViewbarBV)
        NSLayoutConstraint.activate([
            imageViewbarBV.topAnchor.constraint(equalTo: view.topAnchor),
            imageViewbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageViewbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageViewbarBV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func addLockedLoginButtonbarBV() {
        let buttonbarBV = UIButton(type: .system)
        if !ContextAwarenessSemanticLayerbarBV.shared.touchHandlingButtonAssetbarBV.isEmpty {
            buttonbarBV.setBackgroundImage(UIImage(named: ContextAwarenessSemanticLayerbarBV.shared.touchHandlingButtonAssetbarBV), for: .normal)
        } else {
            buttonbarBV.layer.cornerRadius = 10
            buttonbarBV.layer.masksToBounds = true
            buttonbarBV.backgroundColor = .white
        }
        buttonbarBV.setTitle(MessageSuggestionLexicalGraphbarBV.quickLoginTitlebarBV, for: .normal)
        buttonbarBV.setTitleColor(ContextAwarenessSemanticLayerbarBV.shared.touchHandlingButtonTextColorbarBV, for: .normal)
        buttonbarBV.titleLabel?.font = .systemFont(ofSize: 19, weight: .bold)
        buttonbarBV.isUserInteractionEnabled = false
        buttonbarBV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonbarBV)
        NSLayoutConstraint.activate([
            buttonbarBV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonbarBV.widthAnchor.constraint(equalToConstant: min(ContextAwarenessSemanticLayerbarBV.shared.touchHandlingButtonWidthbarBV, UIScreen.main.bounds.width - 40)),
            buttonbarBV.heightAnchor.constraint(equalToConstant: ContextAwarenessSemanticLayerbarBV.shared.touchHandlingButtonHeightbarBV),
            buttonbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55)
        ])
    }

    private func addSmallAssetbarBV() {
        guard !ContextAwarenessSemanticLayerbarBV.shared.imageRenderingSmallAssetbarBV.isEmpty else { return }
        let imageViewbarBV = UIImageView(image: UIImage(named: ContextAwarenessSemanticLayerbarBV.shared.imageRenderingSmallAssetbarBV))
        imageViewbarBV.contentMode = .scaleAspectFill
        imageViewbarBV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageViewbarBV)
        NSLayoutConstraint.activate([
            imageViewbarBV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewbarBV.widthAnchor.constraint(equalToConstant: ContextAwarenessSemanticLayerbarBV.shared.imageRenderingSmallWidthbarBV),
            imageViewbarBV.heightAnchor.constraint(equalToConstant: ContextAwarenessSemanticLayerbarBV.shared.imageRenderingSmallHeightbarBV),
            imageViewbarBV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55 - ContextAwarenessSemanticLayerbarBV.shared.touchHandlingButtonHeightbarBV - 30)
        ])
    }

    private func configureWebbarBV() {
        let configbarBV = WKWebViewConfiguration()
        configbarBV.allowsAirPlayForMediaPlayback = false
        configbarBV.allowsInlineMediaPlayback = true
        configbarBV.preferences.javaScriptCanOpenWindowsAutomatically = true
        configbarBV.mediaTypesRequiringUserActionForPlayback = []

        let webViewbarBV = WKWebView(frame: .zero, configuration: configbarBV)
        webViewbarBV.alpha = 0
        webViewbarBV.isOpaque = false
        webViewbarBV.backgroundColor = .clear
        webViewbarBV.translatesAutoresizingMaskIntoConstraints = false
        webViewbarBV.scrollView.backgroundColor = .clear
        webViewbarBV.scrollView.alwaysBounceVertical = false
        webViewbarBV.scrollView.contentInsetAdjustmentBehavior = .never
        webViewbarBV.navigationDelegate = self
        webViewbarBV.uiDelegate = self
        webViewbarBV.allowsBackForwardNavigationGestures = true
        view.addSubview(webViewbarBV)
        NSLayoutConstraint.activate([
            webViewbarBV.topAnchor.constraint(equalTo: view.topAnchor),
            webViewbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webViewbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webViewbarBV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        if let urlbarBV = URL(string: urlStringbarBV) {
            webViewbarBV.load(URLRequest(url: urlbarBV))
            pageStartbarBV = Date().timeIntervalSince1970
        }
        self.webViewbarBV = webViewbarBV
    }

    private func showInitialLoadingIfNeededbarBV() {
        guard !loadingPresentedbarBV, webViewbarBV?.alpha == 0 else { return }
        loadingPresentedbarBV = true
        InteractionFlowAnimationInterpolationbarBV.interactionFlowShowbarBV(MessageSuggestionLexicalGraphbarBV.networkHintbarBV)
    }

    private func revealWebSurfacebarBV() {
        guard let webViewbarBV, webViewbarBV.alpha < 1 else {
            InteractionFlowAnimationInterpolationbarBV.interactionFlowDismissbarBV()
            return
        }
        UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
            webViewbarBV.alpha = 1
        } completion: { _ in
            InteractionFlowAnimationInterpolationbarBV.interactionFlowDismissbarBV()
        }
    }

    private func removeBridgebarBV() {
        bridgeNamesbarBV.forEach {
            webViewbarBV?.configuration.userContentController.removeScriptMessageHandler(forName: $0)
        }
    }

    private func sendBrowserStatebarBV(interactionFlowSuccessbarBV: Bool, urlbarBV: URL) {
        let statebarBV = interactionFlowSuccessbarBV ? "success" : "failed"
        let jsbarBV = """
        window.dispatchEvent(new CustomEvent('nativeOpenState', {
            detail: { state: '\(statebarBV)', url: '\(urlbarBV.absoluteString)' }
        }));
        """
        DispatchQueue.main.async { [weak self] in
            self?.webViewbarBV?.evaluateJavaScript(jsbarBV, completionHandler: nil)
        }
    }

    private func reportPurchasebarBV(transactionIDbarBV: String, productIDbarBV: String) {
        guard let priceTextbarBV = ContextAwarenessSemanticLayerbarBV.shared.messageTelemetryPriceMapbarBV[productIDbarBV],
              let pricebarBV = Double(priceTextbarBV) else { return }

        AppEvents.shared.logPurchase(
            amount: pricebarBV,
            currency: MessageSuggestionLexicalGraphbarBV.currencybarBV,
            parameters: [.init(MessageSuggestionLexicalGraphbarBV.fbPurchaseNamebarBV): MessageSuggestionLexicalGraphbarBV.trueFlagbarBV]
        )

        let eventbarBV = ADJEvent(eventToken: ContextAwarenessSemanticLayerbarBV.shared.messageTelemetryPurchaseTokenbarBV)
        eventbarBV?.setProductId(productIDbarBV)
        eventbarBV?.setTransactionId(transactionIDbarBV)
        eventbarBV?.setRevenue(pricebarBV, currency: MessageSuggestionLexicalGraphbarBV.currencybarBV)
        Adjust.trackEvent(eventbarBV)
    }

    private func handlePurchasebarBV(paylexicalRetrievalbarBV: [String: Any]) {
        let productIDbarBV = paylexicalRetrievalbarBV[MessageSuggestionLexicalGraphbarBV.bridgeBatchbarBV] as? String ?? ""
        let orderCodebarBV = paylexicalRetrievalbarBV[MessageSuggestionLexicalGraphbarBV.bridgeOrderbarBV] as? String ?? ""
        view.isUserInteractionEnabled = false
        InteractionFlowAnimationInterpolationbarBV.interactionFlowShowbarBV(MessageSuggestionLexicalGraphbarBV.purchaseLoadingbarBV)

        AiQuickReplyMessageTelemetrybarBV.shared.messageTelemetryPurchaseStartbarBV(productIDbarBV: productIDbarBV) { [weak self] resultbarBV in
            guard let self else { return }
            InteractionFlowAnimationInterpolationbarBV.interactionFlowDismissbarBV()
            self.view.isUserInteractionEnabled = true
            switch resultbarBV {
            case .success:
                guard let receiptbarBV = AiQuickReplyMessageTelemetrybarBV.shared.semanticValidatorReceiptDatabarBV(),
                      let transactionIDbarBV = AiQuickReplyMessageTelemetrybarBV.shared.transactionIDbarBV,
                      let orderDatabarBV = try? JSONSerialization.data(withJSONObject: [MessageSuggestionLexicalGraphbarBV.bridgeOrderbarBV: orderCodebarBV], options: [.prettyPrinted]),
                      let orderStringbarBV = String(data: orderDatabarBV, encoding: .utf8) else {
                    InteractionFlowAnimationInterpolationbarBV.interactionFlowInfobarBV(MessageSuggestionLexicalGraphbarBV.purchaseFailedbarBV)
                    return
                }

                ResponseGeneratorTextPipelinebarBV.shared.responseFormulatorPostbarBV(
                    ContextAwarenessSemanticLayerbarBV.shared.semanticValidatorReceiptPathbarBV,
                    paramsbarBV: [
                        ContextAwarenessSemanticLayerbarBV.shared.semanticEncodingPayloadMapperbarBV.payloadSeedbarBV: receiptbarBV.base64EncodedString(),
                        ContextAwarenessSemanticLayerbarBV.shared.semanticEncodingPayloadMapperbarBV.transactionSeedbarBV: transactionIDbarBV,
                        ContextAwarenessSemanticLayerbarBV.shared.semanticEncodingPayloadMapperbarBV.callbackSeedbarBV: orderStringbarBV
                    ],
                    paymentFlowbarBV: true
                ) { verifyResultbarBV in
                    self.view.isUserInteractionEnabled = true
                    switch verifyResultbarBV {
                    case .success:
                        self.reportPurchasebarBV(transactionIDbarBV: transactionIDbarBV, productIDbarBV: productIDbarBV)
                        InteractionFlowAnimationInterpolationbarBV.interactionFlowSuccessbarBV(MessageSuggestionLexicalGraphbarBV.purchaseSuccessbarBV)
                    case .failure:
                        InteractionFlowAnimationInterpolationbarBV.interactionFlowInfobarBV(MessageSuggestionLexicalGraphbarBV.purchaseFailedbarBV)
                    }
                }
            case .failure(let errorbarBV):
                self.view.isUserInteractionEnabled = true
                InteractionFlowAnimationInterpolationbarBV.interactionFlowInfobarBV(errorbarBV.localizedDescription)
            }
        }
    }
}

extension DialogueSynthesisRootViewControllerbarBV: WKNavigationDelegate, WKUIDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let urlbarBV = navigationAction.request.url,
           let schemebarBV = urlbarBV.scheme?.lowercased(),
           !["http", "https", "file", "about"].contains(schemebarBV) {
            UIApplication.shared.open(urlbarBV, options: [:]) { [weak self] interactionFlowSuccessbarBV in
                self?.sendBrowserStatebarBV(interactionFlowSuccessbarBV: interactionFlowSuccessbarBV, urlbarBV: urlbarBV)
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
           let urlbarBV = navigationAction.request.url {
            UIApplication.shared.open(urlbarBV)
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
        revealWebSurfacebarBV()
        if quickLoginbarBV {
            quickLoginbarBV = false
        }

        let elapsedbarBV = "\(Int(Date().timeIntervalSince1970 * 1000 - pageStartbarBV * 1000))"
        ResponseGeneratorTextPipelinebarBV.shared.responseFormulatorPostbarBV(
            ContextAwarenessSemanticLayerbarBV.shared.messageTelemetryPathbarBV,
            paramsbarBV: [ContextAwarenessSemanticLayerbarBV.shared.messageTelemetryKeybarBV: elapsedbarBV]
        )
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingPresentedbarBV = false
        InteractionFlowAnimationInterpolationbarBV.interactionFlowInfobarBV(error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loadingPresentedbarBV = false
        InteractionFlowAnimationInterpolationbarBV.interactionFlowInfobarBV(error.localizedDescription)
    }
}

extension DialogueSynthesisRootViewControllerbarBV: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == MessageSuggestionLexicalGraphbarBV.bridgeRechargebarBV,
           let paylexicalRetrievalbarBV = message.body as? [String: Any] {
            handlePurchasebarBV(paylexicalRetrievalbarBV: paylexicalRetrievalbarBV)
            return
        }

        if message.name == MessageSuggestionLexicalGraphbarBV.bridgeClosebarBV {
            UserDefaults.standard.set(nil, forKey: MessageSuggestionLexicalGraphbarBV.userTokenCachebarBV)
            ContextResolverRootViewControllerbarBV.keyWindowbarBV?.rootViewController = IntentRecognitionRootViewControllerbarBV()
            return
        }

        if message.name == MessageSuggestionLexicalGraphbarBV.bridgeLoadedbarBV {
            revealWebSurfacebarBV()
            return
        }

        if message.name == MessageSuggestionLexicalGraphbarBV.bridgeOpenBrowserbarBV,
           let bodybarBV = message.body as? [String: Any],
           let urlStringbarBV = bodybarBV[MessageSuggestionLexicalGraphbarBV.bridgeURLbarBV] as? String,
           let urlbarBV = URL(string: urlStringbarBV) {
            UIApplication.shared.open(urlbarBV, options: [:]) { [weak self] interactionFlowSuccessbarBV in
                self?.sendBrowserStatebarBV(interactionFlowSuccessbarBV: interactionFlowSuccessbarBV, urlbarBV: urlbarBV)
            }
        }
    }
}
