import UIKit

final class InteractionFlowAnimationInterpolationbarBV {
    static let shared = InteractionFlowAnimationInterpolationbarBV()

    private var overlayWindowbarBV: UIWindow?
    private var indicatorbarBV: UIActivityIndicatorView?

    private init() {}

    static func interactionFlowShowbarBV(_ messagebarBV: String) {
        shared.modalPresentationStatusbarBV(messagebarBV: messagebarBV, iconbarBV: nil, loadingbarBV: true)
    }

    static func interactionFlowInfobarBV(_ messagebarBV: String) {
        shared.modalPresentationStatusbarBV(messagebarBV: messagebarBV, iconbarBV: UIImage(systemName: MessageSuggestionLexicalGraphbarBV.symbolInfobarBV), loadingbarBV: false)
    }

    static func interactionFlowSuccessbarBV(_ messagebarBV: String) {
        shared.modalPresentationStatusbarBV(messagebarBV: messagebarBV, iconbarBV: UIImage(systemName: MessageSuggestionLexicalGraphbarBV.symbolCheckbarBV), loadingbarBV: false)
    }

    static func interactionFlowDismissbarBV() {
        shared.interactionFlowDismissbarBV()
    }

    private func modalPresentationStatusbarBV(messagebarBV: String, iconbarBV: UIImage?, loadingbarBV: Bool) {
        interactionFlowDismissbarBV()

        guard let sceneWindowbarBV = activeOverlayScenebarBV() else { return }
        let windowbarBV = UIWindow(windowScene: sceneWindowbarBV)
        windowbarBV.windowLevel = .alert + 20
        windowbarBV.backgroundColor = .clear
        windowbarBV.frame = sceneWindowbarBV.coordinateSpace.bounds

        let rootbarBV = UIViewController()
        rootbarBV.view.backgroundColor = .clear
        windowbarBV.rootViewController = rootbarBV

        let containerbarBV = UIView()
        containerbarBV.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        containerbarBV.layer.cornerRadius = 14
        containerbarBV.translatesAutoresizingMaskIntoConstraints = false

        let stackbarBV = UIStackView()
        stackbarBV.axis = .vertical
        stackbarBV.alignment = .center
        stackbarBV.spacing = 12
        stackbarBV.translatesAutoresizingMaskIntoConstraints = false

        let indicatorViewbarBV = UIActivityIndicatorView(style: .large)
        indicatorViewbarBV.color = .white
        indicatorViewbarBV.stopAnimating()

        let iconViewbarBV = UIImageView(image: iconbarBV)
        iconViewbarBV.tintColor = .white
        iconViewbarBV.contentMode = .scaleAspectFit
        iconViewbarBV.translatesAutoresizingMaskIntoConstraints = false
        iconViewbarBV.widthAnchor.constraint(equalToConstant: 36).isActive = true
        iconViewbarBV.heightAnchor.constraint(equalToConstant: 36).isActive = true

        let labelbarBV = UILabel()
        labelbarBV.text = messagebarBV
        labelbarBV.textColor = .white
        labelbarBV.font = .systemFont(ofSize: 15, weight: .medium)
        labelbarBV.numberOfLines = 2
        labelbarBV.textAlignment = .center

        if loadingbarBV {
            stackbarBV.addArrangedSubview(indicatorViewbarBV)
            indicatorViewbarBV.startAnimating()
        } else if iconbarBV != nil {
            stackbarBV.addArrangedSubview(iconViewbarBV)
        }
        stackbarBV.addArrangedSubview(labelbarBV)

        containerbarBV.addSubview(stackbarBV)
        rootbarBV.view.addSubview(containerbarBV)
        NSLayoutConstraint.activate([
            containerbarBV.centerXAnchor.constraint(equalTo: rootbarBV.view.centerXAnchor),
            containerbarBV.centerYAnchor.constraint(equalTo: rootbarBV.view.centerYAnchor),
            containerbarBV.widthAnchor.constraint(lessThanOrEqualToConstant: 220),
            stackbarBV.topAnchor.constraint(equalTo: containerbarBV.topAnchor, constant: 20),
            stackbarBV.bottomAnchor.constraint(equalTo: containerbarBV.bottomAnchor, constant: -20),
            stackbarBV.leadingAnchor.constraint(equalTo: containerbarBV.leadingAnchor, constant: 16),
            stackbarBV.trailingAnchor.constraint(equalTo: containerbarBV.trailingAnchor, constant: -16)
        ])

        overlayWindowbarBV = windowbarBV
        indicatorbarBV = indicatorViewbarBV
        windowbarBV.isHidden = false

        containerbarBV.alpha = 0
        containerbarBV.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        UIView.animate(withDuration: 0.24, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            containerbarBV.alpha = 1
            containerbarBV.transform = .identity
        }

        if !loadingbarBV {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.interactionFlowDismissbarBV()
            }
        }
    }

    private func interactionFlowDismissbarBV() {
        overlayWindowbarBV?.isHidden = true
        overlayWindowbarBV = nil
        indicatorbarBV?.stopAnimating()
        indicatorbarBV = nil
    }

    private func activeOverlayScenebarBV() -> UIWindowScene? {
        let scenesbarBV = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        if let activebarBV = scenesbarBV.first(where: { $0.activationState == .foregroundActive }) {
            return activebarBV
        }
        if let inactivebarBV = scenesbarBV.first(where: { $0.activationState == .foregroundInactive }) {
            return inactivebarBV
        }
        return scenesbarBV.first
    }
}
