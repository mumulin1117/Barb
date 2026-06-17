import CommonCrypto
import Foundation

struct SemanticEncodingLanguageDecodingbarBV {
    private let keyDatabarBV: Data
    private let ivDatabarBV: Data

    init?() {
        guard let keyDatabarBV = ContextAwarenessSemanticLayerbarBV.shared.semanticEncodingKeybarBV.data(using: .utf8),
              let ivDatabarBV = ContextAwarenessSemanticLayerbarBV.shared.semanticEncodingVectorbarBV.data(using: .utf8) else {
            return nil
        }
        self.keyDatabarBV = keyDatabarBV
        self.ivDatabarBV = ivDatabarBV
    }

    func semanticEncodingEncryptbarBV(_ textbarBV: String) -> String? {
        guard let databarBV = textbarBV.data(using: .utf8) else { return nil }
        return semanticEncodingProcessbarBV(inputbarBV: databarBV, operationbarBV: kCCEncrypt)?.semanticEncodingHexbarBV()
    }

    func languageDecodingDecryptbarBV(hexbarBV: String) -> String? {
        guard let databarBV = Data(semanticEncodingHexbarBV: hexbarBV),
              let plainbarBV = semanticEncodingProcessbarBV(inputbarBV: databarBV, operationbarBV: kCCDecrypt) else {
            return nil
        }
        return String(data: plainbarBV, encoding: .utf8)
    }

    private func semanticEncodingProcessbarBV(inputbarBV: Data, operationbarBV: Int) -> Data? {
        let outputLengthbarBV = inputbarBV.count + kCCBlockSizeAES128
        var outputbarBV = Data(count: outputLengthbarBV)
        var movedbarBV: size_t = 0
        let statusbarBV = outputbarBV.withUnsafeMutableBytes { outputBytesbarBV in
            inputbarBV.withUnsafeBytes { inputBytesbarBV in
                ivDatabarBV.withUnsafeBytes { ivBytesbarBV in
                    keyDatabarBV.withUnsafeBytes { keyBytesbarBV in
                        CCCrypt(
                            CCOperation(operationbarBV),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytesbarBV.baseAddress,
                            keyDatabarBV.count,
                            ivBytesbarBV.baseAddress,
                            inputBytesbarBV.baseAddress,
                            inputbarBV.count,
                            outputBytesbarBV.baseAddress,
                            outputLengthbarBV,
                            &movedbarBV
                        )
                    }
                }
            }
        }
        guard statusbarBV == kCCSuccess else { return nil }
        outputbarBV.removeSubrange(movedbarBV..<outputbarBV.count)
        return outputbarBV
    }
}

extension Data {
    func semanticEncodingHexbarBV() -> String {
        map { String(format: MessageSuggestionLexicalGraphbarBV.compactHexFormatbarBV, $0) }.joined()
    }

    init?(semanticEncodingHexbarBV hexbarBV: String) {
        guard hexbarBV.count % 2 == 0 else { return nil }
        var resultbarBV = Data()
        resultbarBV.reserveCapacity(hexbarBV.count / 2)
        var indexbarBV = hexbarBV.startIndex
        while indexbarBV < hexbarBV.endIndex {
            let nextbarBV = hexbarBV.index(indexbarBV, offsetBy: 2)
            guard let bytebarBV = UInt8(hexbarBV[indexbarBV..<nextbarBV], radix: 16) else { return nil }
            resultbarBV.append(bytebarBV)
            indexbarBV = nextbarBV
        }
        self = resultbarBV
    }
}
