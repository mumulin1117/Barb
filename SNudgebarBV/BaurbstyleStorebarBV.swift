import UIKit

enum
BaurbstyleStorebarBV {
    static let backgroundTop = UIColor(red: 220 / 255, green: 250 / 255, blue: 1, alpha: 1)
    static let backgroundBottom = UIColor(red: 253 / 255, green: 237 / 255, blue: 245 / 255, alpha: 1)
    static let blue = UIColor(red: 48 / 255, green: 158 / 255, blue: 246 / 255, alpha: 1)
    static let purple = UIColor(red: 82 / 255, green: 28 / 255, blue: 245 / 255, alpha: 1)
    static let pink = UIColor(red: 247 / 255, green: 128 / 255, blue: 168 / 255, alpha: 1)
    static let mint = UIColor(red: 43 / 255, green: 210 / 255, blue: 229 / 255, alpha: 1)
    static let mutedText = UIColor(red: 135 / 255, green: 135 / 255, blue: 145 / 255, alpha: 1)
    static let card = UIColor.white.withAlphaComponent(0.94)
    static let cardStripColorsbarBV = [
        UIColor(red: 1, green: 92 / 255, blue: 190 / 255, alpha: 1),
        UIColor(red: 161 / 255, green: 233 / 255, blue: 1, alpha: 1),
        UIColor(red: 237 / 255, green: 252 / 255, blue: 1, alpha: 1),
        UIColor(red: 1, green: 198 / 255, blue: 253 / 255, alpha: 1),
        UIColor(red: 161 / 255, green: 233 / 255, blue: 1, alpha: 1),
        UIColor.white
    ]
    static let cardStripLocationsbarBV: [NSNumber] = [0, 0.1417, 0.2914, 0.469, 0.6154, 0.9856]
    static let replyChoiceColorsbarBV = [
        UIColor(red: 1, green: 139 / 255, blue: 1, alpha: 1),
        UIColor(red: 103 / 255, green: 153 / 255, blue: 1, alpha: 1),
        UIColor(red: 38 / 255, green: 215 / 255, blue: 251 / 255, alpha: 1)
    ]
    static let replyChoiceLocationsbarBV: [NSNumber] = [0, 0.5192, 1]

    static var scaleWidthbarBV: CGFloat {
        let widthbarBV = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return min(max(widthbarBV / 375, 0.84), 1.08)
    }

    static var heightScalebarBV: CGFloat {
        let heightbarBV = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return min(max(heightbarBV / 812, 0.78), 1.04)
    }

    static var compactHeightbarBV: Bool {
        max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) <= 700
    }

    static func metricbarBV(_ valuebarBV: CGFloat, minimumbarBV: CGFloat? = nil, maximumbarBV: CGFloat? = nil) -> CGFloat {
        let scaledbarBV = (valuebarBV * scaleWidthbarBV).rounded(.toNearestOrAwayFromZero)
        return min(max(scaledbarBV, minimumbarBV ?? valuebarBV * 0.82), maximumbarBV ?? valuebarBV * 1.08)
    }

    static func spacebarBV(_ valuebarBV: CGFloat, minimumbarBV: CGFloat? = nil, maximumbarBV: CGFloat? = nil) -> CGFloat {
        let scaledbarBV = (valuebarBV * heightScalebarBV).rounded(.toNearestOrAwayFromZero)
        return min(max(scaledbarBV, minimumbarBV ?? valuebarBV * 0.62), maximumbarBV ?? valuebarBV)
    }

    static func controlbarBV(_ valuebarBV: CGFloat = 56) -> CGFloat {
        min(max(metricbarBV(valuebarBV, minimumbarBV: 44, maximumbarBV: 60), 44), 60)
    }

    static func sizebarBV(_ valuebarBV: CGFloat) -> CGFloat {
        (valuebarBV * scaleWidthbarBV).rounded(.toNearestOrAwayFromZero)
    }

    static func fontbarBV(_ size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        .systemFont(ofSize: sizebarBV(size), weight: weight)
    }

    static func italicFontbarBV(_ size: CGFloat) -> UIFont {
        .italicSystemFont(ofSize: sizebarBV(size))
    }

    static func titleFont(_ size: CGFloat) -> UIFont {
        fontbarBV(size, weight: .heavy)
    }

    static func bodyFont(_ size: CGFloat) -> UIFont {
        fontbarBV(size, weight: .regular)
    }

    static func labelFitbarBV(_ labelbarBV: UILabel, factorbarBV: CGFloat = 0.72, linesbarBV: Int? = nil) {
        labelbarBV.adjustsFontSizeToFitWidth = true
        labelbarBV.minimumScaleFactor = factorbarBV
        labelbarBV.lineBreakMode = .byWordWrapping
        if let linesbarBV {
            labelbarBV.numberOfLines = linesbarBV
        }
    }

    static func buttonFitbarBV(_ buttonbarBV: UIButton, factorbarBV: CGFloat = 0.72) {
        buttonbarBV.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonbarBV.titleLabel?.minimumScaleFactor = factorbarBV
        buttonbarBV.titleLabel?.lineBreakMode = .byTruncatingTail
    }

    static func gradientLayer(
        bounds: CGRect,
        cornerRadius: CGFloat,
        colorsbarBV: [UIColor]? = nil,
        locationsbarBV: [NSNumber]? = nil
    ) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = (colorsbarBV ?? [mint, purple, pink]).map(\.cgColor)
        layer.locations = locationsbarBV
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = cornerRadius
        return layer
    }
}
