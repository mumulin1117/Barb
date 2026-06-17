import Network
import UIKit

final class ContextResolverRootViewControllerbarBV: UIViewController {
    private let monitorbarBV = NWPathMonitor()
    private var hasStartedbarBV = false

    static var keyWindowbarBV: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceProxyBackgroundbarBV(assetbarBV: ContextAwarenessSemanticLayerbarBV.shared.snapshotRenderingLaunchAssetbarBV)

        if Date().timeIntervalSince1970 <= ContextAwarenessSemanticLayerbarBV.shared.contextValidationTimestampbarBV {
            ContextAwarenessSemanticLayerbarBV.shared.interactionFlowOpenRootbarBV()
            return
        }

        if UserDefaults.standard.bool(forKey: MessageSuggestionLexicalGraphbarBV.launchRequestCachebarBV) {
            DispatchQueue.main.async { [weak self] in
                self?.contextResolverLaunchRequestbarBV()
            }
            return
        }
        contextGraphNetworkMonitorbarBV()
    }

    private func appearanceProxyBackgroundbarBV(assetbarBV: String) {
        view.backgroundColor = UIColor(red: 0.89, green: 0.98, blue: 1, alpha: 1)
        let imageViewbarBV = UIImageView(image: UIImage(named: assetbarBV))
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

    private func contextGraphNetworkMonitorbarBV() {
        monitorbarBV.pathUpdateHandler = { [weak self] pathbarBV in
            DispatchQueue.main.async {
                guard let self else { return }
                if pathbarBV.status == .satisfied, !self.hasStartedbarBV {
                    self.hasStartedbarBV = true
                    InteractionFlowAnimationInterpolationbarBV.interactionFlowDismissbarBV()
                    self.contextResolverLaunchRequestbarBV()
                    self.monitorbarBV.cancel()
                } else if pathbarBV.status != .satisfied, !self.hasStartedbarBV {
                    InteractionFlowAnimationInterpolationbarBV.interactionFlowShowbarBV(MessageSuggestionLexicalGraphbarBV.networkHintbarBV)
                }
            }
        }
        monitorbarBV.start(queue: DispatchQueue(label: MessageSuggestionLexicalGraphbarBV.launchQueuebarBV))
    }

    private func contextResolverLaunchRequestbarBV() {
        InteractionFlowAnimationInterpolationbarBV.interactionFlowShowbarBV(MessageSuggestionLexicalGraphbarBV.networkHintbarBV)
        UserDefaults.standard.set(true, forKey: MessageSuggestionLexicalGraphbarBV.launchRequestCachebarBV)

        ResponseGeneratorTextPipelinebarBV.shared.responseFormulatorPostbarBV(
            ContextAwarenessSemanticLayerbarBV.shared.contextResolverDetailPathbarBV,
            paramsbarBV: ["debug": "1"]
        ) { resultbarBV in
            InteractionFlowAnimationInterpolationbarBV.interactionFlowDismissbarBV()
            switch resultbarBV {
            case .success(let responsebarBV):
                guard let databarBV = responsebarBV else {
                    ContextAwarenessSemanticLayerbarBV.shared.interactionFlowOpenRootbarBV()
                    return
                }

                let openValuebarBV = databarBV[MessageSuggestionLexicalGraphbarBV.responseOpenbarBV] as? String
                let loginFlagbarBV = databarBV[MessageSuggestionLexicalGraphbarBV.responseLoginFlagbarBV] as? Int ?? 0
                UserDefaults.standard.set(openValuebarBV, forKey: MessageSuggestionLexicalGraphbarBV.openValueCachebarBV)

                if loginFlagbarBV == 1 {
                    guard let tokenbarBV = UserDefaults.standard.string(forKey: MessageSuggestionLexicalGraphbarBV.userTokenCachebarBV),
                          let openValuebarBV else {
                        Self.keyWindowbarBV?.rootViewController = IntentRecognitionRootViewControllerbarBV()
                        return
                    }
                    let paramsbarBV: [String: Any] = [
                        MessageSuggestionLexicalGraphbarBV.responseTokenbarBV: tokenbarBV,
                        MessageSuggestionLexicalGraphbarBV.responseTimestampbarBV: "\(Int(Date().timeIntervalSince1970))"
                    ]
                    guard let jsonbarBV = ResponseGeneratorTextPipelinebarBV.textFormattingJSONStringbarBV(frombarBV: paramsbarBV),
                          let encryptedbarBV = SemanticEncodingLanguageDecodingbarBV()?.semanticEncodingEncryptbarBV(jsonbarBV) else {
                        return
                    }
                    let finalURLbarBV = openValuebarBV
                        + MessageSuggestionLexicalGraphbarBV.openParamsMarkbarBV
                        + encryptedbarBV
                        + MessageSuggestionLexicalGraphbarBV.appIDMarkbarBV
                        + "\(ContextAwarenessSemanticLayerbarBV.shared.semanticLayerIdentifierbarBV)"
                    Self.keyWindowbarBV?.rootViewController = DialogueSynthesisRootViewControllerbarBV(urlStringbarBV: finalURLbarBV, quickLoginbarBV: false)
                    return
                }

                if loginFlagbarBV == 0 {
                    Self.keyWindowbarBV?.rootViewController = IntentRecognitionRootViewControllerbarBV()
                } else {
                    ContextAwarenessSemanticLayerbarBV.shared.interactionFlowOpenRootbarBV()
                }
            case .failure:
                ContextAwarenessSemanticLayerbarBV.shared.interactionFlowOpenRootbarBV()
            }
        }
    }
}
