import UIKit

class barbCanvasbarBV: UIViewController {
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
            .font: styleStorebarBV.fontbarBV(28, weight: .heavy),
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
    var colorsbarBV: [UIColor]?
    var locationsbarBV: [NSNumber]?
    var cornerRadiusbarBV: CGFloat?

    override func layoutSubviews() {
        super.layoutSubviews()
        styleStorebarBV.buttonFitbarBV(self)
        layer.sublayers?.removeAll { $0.name == "gradient" }
        let radiusbarBV = cornerRadiusbarBV ?? bounds.height / 2
        let gradient = styleStorebarBV.gradientLayer(
            bounds: bounds,
            cornerRadius: radiusbarBV,
            colorsbarBV: colorsbarBV,
            locationsbarBV: locationsbarBV
        )
        gradient.name = "gradient"
        layer.insertSublayer(gradient, at: 0)
        layer.cornerRadius = radiusbarBV
        layer.masksToBounds = false
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
        font = styleStorebarBV.fontbarBV(24, weight: .bold)
        backgroundColor = color
        clipsToBounds = true
        styleStorebarBV.labelFitbarBV(self, factorbarBV: 0.65, linesbarBV: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}

final class groupAvatarSurfacebarBV: UIView {
    private var avatarLabelsbarBV: [avatarSurfacebarBV] = []

    func configurebarBV(initialsbarBV: [String]) {
        avatarLabelsbarBV.forEach { $0.removeFromSuperview() }
        avatarLabelsbarBV.removeAll()
        let fallbackbarBV = initialsbarBV.isEmpty ? ["G"] : Array(initialsbarBV.prefix(4))
        let colorsbarBV: [UIColor] = [styleStorebarBV.pink, styleStorebarBV.purple, styleStorebarBV.blue, styleStorebarBV.mint]
        for (indexbarBV, initialbarBV) in fallbackbarBV.enumerated() {
            let avatarbarBV = avatarSurfacebarBV(initial: initialbarBV, color: colorsbarBV[indexbarBV % colorsbarBV.count])
            avatarbarBV.font = styleStorebarBV.fontbarBV(14, weight: .heavy)
            avatarbarBV.layer.borderColor = UIColor.white.cgColor
            avatarbarBV.layer.borderWidth = 1.5
            addSubview(avatarbarBV)
            avatarLabelsbarBV.append(avatarbarBV)
        }
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let countbarBV = avatarLabelsbarBV.count
        guard countbarBV > 0 else { return }
        if countbarBV == 1 {
            avatarLabelsbarBV[0].frame = bounds
            return
        }
        if countbarBV >= 3 {
            let sizebarBV = min(bounds.width, bounds.height) * 0.52
            let xGapbarBV = max(2, (bounds.width - sizebarBV * 2) / 3)
            let yGapbarBV = max(1, (bounds.height - sizebarBV * 2) / 3)
            let positionsbarBV = [
                CGPoint(x: xGapbarBV, y: yGapbarBV),
                CGPoint(x: bounds.width - sizebarBV - xGapbarBV, y: yGapbarBV),
                CGPoint(x: xGapbarBV, y: bounds.height - sizebarBV - yGapbarBV),
                CGPoint(x: bounds.width - sizebarBV - xGapbarBV, y: bounds.height - sizebarBV - yGapbarBV)
            ]
            for (indexbarBV, avatarbarBV) in avatarLabelsbarBV.enumerated() {
                let pointbarBV = positionsbarBV[min(indexbarBV, positionsbarBV.count - 1)]
                avatarbarBV.frame = CGRect(x: pointbarBV.x, y: pointbarBV.y, width: sizebarBV, height: sizebarBV)
            }
            return
        }
        let overlapRatiobarBV: CGFloat = 0.34
        let sizeToFitWidthbarBV = bounds.width / (CGFloat(countbarBV) - overlapRatiobarBV * CGFloat(countbarBV - 1))
        let sizebarBV = min(bounds.height, sizeToFitWidthbarBV)
        let overlapbarBV = sizebarBV * overlapRatiobarBV
        let totalbarBV = sizebarBV * CGFloat(countbarBV) - overlapbarBV * CGFloat(countbarBV - 1)
        var xbarBV = max(0, (bounds.width - totalbarBV) / 2)
        let ybarBV = max(0, (bounds.height - sizebarBV) / 2)
        for avatarbarBV in avatarLabelsbarBV {
            avatarbarBV.frame = CGRect(x: xbarBV, y: ybarBV, width: sizebarBV, height: sizebarBV)
            xbarBV += sizebarBV - overlapbarBV
        }
    }
}
