import UIKit
import WebKit

final class IntentRecognitionRootViewControllerbarBV: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceProxyBackgroundbarBV()
        prelexicalRetrievalbarBV()
        addLoginButtonbarBV()
        addSmallAssetbarBV()
    }

    private func appearanceProxyBackgroundbarBV() {
        let imageViewbarBV = UIImageView(image: UIImage(named: ContextAwarenessSemanticLayerbarBV.shared.appearanceProxyBackgroundAssetbarBV))
        imageViewbarBV.contentMode = .scaleAspectFill
        imageViewbarBV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageViewbarBV)
        NSLayoutConstraint.activate([
            imageViewbarBV.topAnchor.constraint(equalTo: view.topAnchor),
            imageViewbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageViewbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageViewbarBV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.backgroundColor = UIColor(red: 0.9, green: 0.98, blue: 1, alpha: 1)
    }

    private func addLoginButtonbarBV() {
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
        buttonbarBV.addTarget(self, action: #selector(loginbarBV(senderbarBV:)), for: .touchUpInside)
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

    private func prelexicalRetrievalbarBV() {
        let configbarBV = WKWebViewConfiguration()
        configbarBV.allowsAirPlayForMediaPlayback = false
        configbarBV.allowsInlineMediaPlayback = true
        configbarBV.preferences.javaScriptCanOpenWindowsAutomatically = true
        configbarBV.mediaTypesRequiringUserActionForPlayback = []
        let webViewbarBV = WKWebView(frame: .zero, configuration: configbarBV)
        webViewbarBV.isHidden = true
        webViewbarBV.scrollView.alwaysBounceVertical = false
        webViewbarBV.scrollView.contentInsetAdjustmentBehavior = .never
        webViewbarBV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webViewbarBV)
        NSLayoutConstraint.activate([
            webViewbarBV.topAnchor.constraint(equalTo: view.topAnchor),
            webViewbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webViewbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webViewbarBV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        if let openbarBV = UserDefaults.standard.string(forKey: MessageSuggestionLexicalGraphbarBV.openValueCachebarBV),
           let urlbarBV = URL(string: openbarBV) {
            webViewbarBV.load(URLRequest(url: urlbarBV))
        }
    }

    @objc private func loginbarBV(senderbarBV: UIButton) {
        senderbarBV.isUserInteractionEnabled = false
        InteractionFlowAnimationInterpolationbarBV.interactionFlowShowbarBV(MessageSuggestionLexicalGraphbarBV.networkHintbarBV)
        var paramsbarBV: [String: Any] = [:]
        paramsbarBV[ContextAwarenessSemanticLayerbarBV.shared.intentParserLexicalSelectionbarBV.deviceSeedbarBV] = ContextCachingLexicalAnchorbarBV.contextCachingDeviceIdentifierbarBV()
        paramsbarBV[ContextAwarenessSemanticLayerbarBV.shared.intentParserLexicalSelectionbarBV.adjustSeedbarBV] = ContextAwarenessSemanticLayerbarBV.shared.messageTelemetryIdentifierbarBV
        if let passwordbarBV = ContextCachingLexicalAnchorbarBV.contextCachingPasscodeRetrievalbarBV() {
            paramsbarBV[ContextAwarenessSemanticLayerbarBV.shared.intentParserLexicalSelectionbarBV.passwordSeedbarBV] = passwordbarBV
        }

        ResponseGeneratorTextPipelinebarBV.shared.responseFormulatorPostbarBV(ContextAwarenessSemanticLayerbarBV.shared.intentRecognitionPathbarBV, paramsbarBV: paramsbarBV) { resultbarBV in
            senderbarBV.isUserInteractionEnabled = true
            InteractionFlowAnimationInterpolationbarBV.interactionFlowDismissbarBV()
            switch resultbarBV {
            case .success(let responsebarBV):
                guard let responsebarBV,
                      let tokenbarBV = responsebarBV[MessageSuggestionLexicalGraphbarBV.responseTokenbarBV] as? String,
                      let openValuebarBV = UserDefaults.standard.string(forKey: MessageSuggestionLexicalGraphbarBV.openValueCachebarBV) else {
                    InteractionFlowAnimationInterpolationbarBV.interactionFlowInfobarBV(MessageSuggestionLexicalGraphbarBV.invalidLoginbarBV)
                    return
                }
                if let passwordbarBV = responsebarBV[MessageSuggestionLexicalGraphbarBV.responsePasswordbarBV] as? String {
                    ContextCachingLexicalAnchorbarBV.contextCachingPasscodeArchivebarBV(passwordbarBV)
                }
                UserDefaults.standard.set(tokenbarBV, forKey: MessageSuggestionLexicalGraphbarBV.userTokenCachebarBV)
                let secureParamsbarBV: [String: Any] = [
                    MessageSuggestionLexicalGraphbarBV.responseTokenbarBV: tokenbarBV,
                    MessageSuggestionLexicalGraphbarBV.responseTimestampbarBV: "\(Int(Date().timeIntervalSince1970))"
                ]
                guard let jsonbarBV = ResponseGeneratorTextPipelinebarBV.textFormattingJSONStringbarBV(frombarBV: secureParamsbarBV),
                      let encryptedbarBV = SemanticEncodingLanguageDecodingbarBV()?.semanticEncodingEncryptbarBV(jsonbarBV) else {
                    return
                }
                let finalURLbarBV = openValuebarBV
                    + MessageSuggestionLexicalGraphbarBV.openParamsMarkbarBV
                    + encryptedbarBV
                    + MessageSuggestionLexicalGraphbarBV.appIDMarkbarBV
                    + "\(ContextAwarenessSemanticLayerbarBV.shared.semanticLayerIdentifierbarBV)"
                ContextResolverRootViewControllerbarBV.keyWindowbarBV?.rootViewController = DialogueSynthesisRootViewControllerbarBV(urlStringbarBV: finalURLbarBV, quickLoginbarBV: true)
            case .failure(let errorbarBV):
                InteractionFlowAnimationInterpolationbarBV.interactionFlowInfobarBV(errorbarBV.localizedDescription)
            }
        }
    }
}
