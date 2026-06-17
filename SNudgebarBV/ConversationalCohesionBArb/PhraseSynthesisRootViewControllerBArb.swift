import UIKit
import WebKit

final class PhraseSynthesisRootViewControllerBArb: UIViewController {
    var viewHierarchyBArb: WKWebView?
    var responseLatencyBArb = Date().timeIntervalSince1970
    var intentRecognitionBArb: Bool
    var presentationControllerBArb = false
    var messageSuggestionContextValidationBArb = false
    let semanticNetworkAdaptiveTextBArb: String
    let dialogueGraphBArb = [
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

    func viewHierarchyNaturalFlowBArb() {
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

    func contextResolverDialogueStateBArb(interactionFlowContextValidationBArb: Bool, semanticNetworkLinkBArb: URL) {
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

}
