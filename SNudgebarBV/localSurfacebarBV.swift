import UIKit

class localSurfacebarBV: UIViewController {
    private let backgroundbarBV = UIImageView(image: UIImage(named: "backgroundbarBV"))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = styleStorebarBV.backgroundTop
        backgroundbarBV.contentMode = .scaleAspectFill
        backgroundbarBV.clipsToBounds = true
        view.insertSubview(backgroundbarBV, at: 0)
        backgroundbarBV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundbarBV.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundbarBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundbarBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundbarBV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 28, weight: .heavy),
            .foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
    }
}

final class offlineSurfacebarBV: UIView {
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        guard let layer = layer as? CAGradientLayer else { return }
        layer.colors = [
            styleStorebarBV.backgroundTop.cgColor,
            UIColor.white.cgColor,
            styleStorebarBV.backgroundBottom.cgColor,
            UIColor(red: 210 / 255, green: 249 / 255, blue: 246 / 255, alpha: 1).cgColor
        ]
        layer.locations = [0, 0.4, 0.72, 1]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
    }
}

final class gradientPill: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.removeAll { $0.name == "gradient" }
        let gradient = styleStorebarBV.gradientLayer(bounds: bounds, cornerRadius: bounds.height / 2)
        gradient.name = "gradient"
        layer.insertSublayer(gradient, at: 0)
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
    }
}

final class cardSurfacebarBV: UIView {
    init(cornerRadius: CGFloat = 24) {
        super.init(frame: .zero)
        backgroundColor = styleStorebarBV.card
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class avatarSurfacebarBV: UILabel {
    init(initial: String, color: UIColor = styleStorebarBV.purple) {
        super.init(frame: .zero)
        text = initial
        textAlignment = .center
        textColor = .white
        font = .systemFont(ofSize: 24, weight: .bold)
        backgroundColor = color
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}
