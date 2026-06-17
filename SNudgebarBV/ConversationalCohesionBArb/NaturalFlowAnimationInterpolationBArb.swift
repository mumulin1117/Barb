import UIKit

final class NaturalFlowAnimationInterpolationBArb {
    static let naturalFlowBArb = NaturalFlowAnimationInterpolationBArb()

    private var popoverPresentationBArb: UIWindow?
    private var animationInterpolationBArb: UIActivityIndicatorView?

    private init() {}

    static func interactionFlowNaturalFlowBArb(_ messageSuggestionTextBArb: String) {
        naturalFlowBArb.modalPresentationStyleBArb(messageSuggestionTextBArb: messageSuggestionTextBArb, uiConfigurationIconBArb: nil, naturalFlowLoadingBArb: true)
    }

    static func interactionFlowDialogueStateBArb(_ messageSuggestionTextBArb: String) {
        naturalFlowBArb.modalPresentationStyleBArb(messageSuggestionTextBArb: messageSuggestionTextBArb, uiConfigurationIconBArb: UIImage(systemName: ReplySuggestionLexicalGraphBArb.uiConfigurationInfoBArb), naturalFlowLoadingBArb: false)
    }

    static func interactionFlowContextValidationBArb(_ messageSuggestionTextBArb: String) {
        naturalFlowBArb.modalPresentationStyleBArb(messageSuggestionTextBArb: messageSuggestionTextBArb, uiConfigurationIconBArb: UIImage(systemName: ReplySuggestionLexicalGraphBArb.uiConfigurationContextValidationBArb), naturalFlowLoadingBArb: false)
    }

    static func interactionFlowPruningBArb() {
        naturalFlowBArb.interactionFlowPruningBArb()
    }

    private func modalPresentationStyleBArb(messageSuggestionTextBArb: String, uiConfigurationIconBArb: UIImage?, naturalFlowLoadingBArb: Bool) {
        interactionFlowPruningBArb()

        guard let windowSceneBArb = windowSceneBArb() else { return }
        let uiWindowSurfaceBArb = UIWindow(windowScene: windowSceneBArb)
        uiWindowSurfaceBArb.windowLevel = .alert + 20
        uiWindowSurfaceBArb.backgroundColor = .clear
        uiWindowSurfaceBArb.frame = windowSceneBArb.coordinateSpace.bounds

        let rootViewControllerSurfaceBArb = UIViewController()
        rootViewControllerSurfaceBArb.view.backgroundColor = .clear
        uiWindowSurfaceBArb.rootViewController = rootViewControllerSurfaceBArb

        let containerViewControllerBArb = UIView()
        containerViewControllerBArb.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        containerViewControllerBArb.layer.cornerRadius = 14
        containerViewControllerBArb.translatesAutoresizingMaskIntoConstraints = false

        let stackViewLayoutBArb = UIStackView()
        stackViewLayoutBArb.axis = .vertical
        stackViewLayoutBArb.alignment = .center
        stackViewLayoutBArb.spacing = 12
        stackViewLayoutBArb.translatesAutoresizingMaskIntoConstraints = false

        let animationInterpolationViewBArb = UIActivityIndicatorView(style: .large)
        animationInterpolationViewBArb.color = .white
        animationInterpolationViewBArb.stopAnimating()

        let uiImageConfigViewBArb = UIImageView(image: uiConfigurationIconBArb)
        uiImageConfigViewBArb.tintColor = .white
        uiImageConfigViewBArb.contentMode = .scaleAspectFit
        uiImageConfigViewBArb.translatesAutoresizingMaskIntoConstraints = false
        uiImageConfigViewBArb.widthAnchor.constraint(equalToConstant: 36).isActive = true
        uiImageConfigViewBArb.heightAnchor.constraint(equalToConstant: 36).isActive = true

        let textAlignmentLabelBArb = UILabel()
        textAlignmentLabelBArb.text = messageSuggestionTextBArb
        textAlignmentLabelBArb.textColor = .white
        textAlignmentLabelBArb.font = .systemFont(ofSize: 15, weight: .medium)
        textAlignmentLabelBArb.numberOfLines = 2
        textAlignmentLabelBArb.textAlignment = .center

        if naturalFlowLoadingBArb {
            stackViewLayoutBArb.addArrangedSubview(animationInterpolationViewBArb)
            animationInterpolationViewBArb.startAnimating()
        } else if uiConfigurationIconBArb != nil {
            stackViewLayoutBArb.addArrangedSubview(uiImageConfigViewBArb)
        }
        stackViewLayoutBArb.addArrangedSubview(textAlignmentLabelBArb)

        containerViewControllerBArb.addSubview(stackViewLayoutBArb)
        rootViewControllerSurfaceBArb.view.addSubview(containerViewControllerBArb)
        NSLayoutConstraint.activate([
            containerViewControllerBArb.centerXAnchor.constraint(equalTo: rootViewControllerSurfaceBArb.view.centerXAnchor),
            containerViewControllerBArb.centerYAnchor.constraint(equalTo: rootViewControllerSurfaceBArb.view.centerYAnchor),
            containerViewControllerBArb.widthAnchor.constraint(lessThanOrEqualToConstant: 220),
            stackViewLayoutBArb.topAnchor.constraint(equalTo: containerViewControllerBArb.topAnchor, constant: 20),
            stackViewLayoutBArb.bottomAnchor.constraint(equalTo: containerViewControllerBArb.bottomAnchor, constant: -20),
            stackViewLayoutBArb.leadingAnchor.constraint(equalTo: containerViewControllerBArb.leadingAnchor, constant: 16),
            stackViewLayoutBArb.trailingAnchor.constraint(equalTo: containerViewControllerBArb.trailingAnchor, constant: -16)
        ])

        popoverPresentationBArb = uiWindowSurfaceBArb
        animationInterpolationBArb = animationInterpolationViewBArb
        uiWindowSurfaceBArb.isHidden = false

        containerViewControllerBArb.alpha = 0
        containerViewControllerBArb.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        UIView.animate(withDuration: 0.24, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            containerViewControllerBArb.alpha = 1
            containerViewControllerBArb.transform = .identity
        }

        if !naturalFlowLoadingBArb {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.interactionFlowPruningBArb()
            }
        }
    }

    private func interactionFlowPruningBArb() {
        popoverPresentationBArb?.isHidden = true
        popoverPresentationBArb = nil
        animationInterpolationBArb?.stopAnimating()
        animationInterpolationBArb = nil
    }

    private func windowSceneBArb() -> UIWindowScene? {
        let windowSceneCollectionBArb = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        if let windowSceneActiveBArb = windowSceneCollectionBArb.first(where: { $0.activationState == .foregroundActive }) {
            return windowSceneActiveBArb
        }
        if let windowSceneInactiveBArb = windowSceneCollectionBArb.first(where: { $0.activationState == .foregroundInactive }) {
            return windowSceneInactiveBArb
        }
        return windowSceneCollectionBArb.first
    }
}
