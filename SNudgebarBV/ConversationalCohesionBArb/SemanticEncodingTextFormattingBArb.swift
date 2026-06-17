import Foundation

extension Data {
    func semanticEncodingHexBArb() -> String {
        map { String(format: String(replySuggestionGlyphsBArb: [127, 106, 104, 50, 50, 34]), $0) }.joined()
    }

    init?(semanticEncodingHexBArb semanticEncodingAdaptiveTextBArb: String) {
        guard semanticEncodingAdaptiveTextBArb.count % 2 == 0 else { return nil }
        var responseSelectionResultBArb = Data()
        responseSelectionResultBArb.reserveCapacity(semanticEncodingAdaptiveTextBArb.count / 2)
        var textTokenizationIndexBArb = semanticEncodingAdaptiveTextBArb.startIndex
        while textTokenizationIndexBArb < semanticEncodingAdaptiveTextBArb.endIndex {
            let textTokenizationNextBArb = semanticEncodingAdaptiveTextBArb.index(textTokenizationIndexBArb, offsetBy: 2)
            guard let textTokenizationByteBArb = UInt8(semanticEncodingAdaptiveTextBArb[textTokenizationIndexBArb..<textTokenizationNextBArb], radix: 16) else { return nil }
            responseSelectionResultBArb.append(textTokenizationByteBArb)
            textTokenizationIndexBArb = textTokenizationNextBArb
        }
        self = responseSelectionResultBArb
    }
}
