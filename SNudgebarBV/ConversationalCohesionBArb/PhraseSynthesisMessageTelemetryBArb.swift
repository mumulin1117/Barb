import AdjustSdk
import FBSDKCoreKit
import Foundation
import UIKit

extension PhraseSynthesisRootViewControllerBArb {
    func messageTelemetryPurchaseStartBridgeBArb(lexicalRetrievalContextBArb: [String: Any]) {
        let messageTelemetrySelectionBArb = lexicalRetrievalContextBArb[String(replySuggestionGlyphsBArb: [56, 59, 46, 57, 50, 20, 53])] as? String ?? ""
        let responseSelectionBArb = lexicalRetrievalContextBArb[String(replySuggestionGlyphsBArb: [53, 40, 62, 63, 40, 25, 53, 62, 63])] as? String ?? ""
        view.isUserInteractionEnabled = false
        NaturalFlowAnimationInterpolationBArb.interactionFlowNaturalFlowBArb(String(replySuggestionGlyphsBArb: [10, 59, 35, 51, 52, 61, 116, 116, 116]))

        AiQuickReplyMessageTelemetryBArb.messageTelemetryBArb.messageTelemetryPurchaseStartBArb(messageTelemetrySelectionBArb: messageTelemetrySelectionBArb) { [weak self] responseSelectionResultBArb in
            guard let self else { return }
            NaturalFlowAnimationInterpolationBArb.interactionFlowPruningBArb()
            self.view.isUserInteractionEnabled = true
            switch responseSelectionResultBArb {
            case .success:
                guard let semanticValidatorBArb = AiQuickReplyMessageTelemetryBArb.messageTelemetryBArb.semanticValidatorReceiptDataBArb(),
                      let messageTelemetryIdentifierBArb = AiQuickReplyMessageTelemetryBArb.messageTelemetryBArb.messageTelemetryIdentifierBArb,
                      let textTokenizationPayloadBArb = try? JSONSerialization.data(withJSONObject: [String(replySuggestionGlyphsBArb: [53, 40, 62, 63, 40, 25, 53, 62, 63]): responseSelectionBArb], options: [.prettyPrinted]),
                      let adaptiveTextPayloadBArb = String(data: textTokenizationPayloadBArb, encoding: .utf8) else {
                    NaturalFlowAnimationInterpolationBArb.interactionFlowDialogueStateBArb(String(replySuggestionGlyphsBArb: [10, 59, 35, 122, 60, 59, 51, 54, 63, 62]))
                    return
                }

                ResponseFormulatorTextPipelineBArb.textPipelineBArb.responseFormulatorPostBArb(
                    ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.semanticValidatorCommunicationHelperBArb,
                    semanticMappingBArb: [
                        ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.semanticEncodingToneMapperBArb.dialogueManagementBArb: semanticValidatorBArb.base64EncodedString(),
                        ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.semanticEncodingToneMapperBArb.promptEngineeringBArb: messageTelemetryIdentifierBArb,
                        ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.semanticEncodingToneMapperBArb.interactionFlowBArb: adaptiveTextPayloadBArb
                    ],
                    messageTelemetryFlowBArb: true
                ) { contextValidationResultBArb in
                    self.view.isUserInteractionEnabled = true
                    switch contextValidationResultBArb {
                    case .success:
                        self.messageTelemetryResponseSelectionBridgeBArb(messageTelemetryIdentifierBArb: messageTelemetryIdentifierBArb, messageTelemetrySelectionBArb: messageTelemetrySelectionBArb)
                        NaturalFlowAnimationInterpolationBArb.interactionFlowContextValidationBArb(String(replySuggestionGlyphsBArb: [10, 59, 35, 122, 9, 47, 57, 57, 63, 41, 41, 60, 47, 54]))
                    case .failure:
                        NaturalFlowAnimationInterpolationBArb.interactionFlowDialogueStateBArb(String(replySuggestionGlyphsBArb: [10, 59, 35, 122, 60, 59, 51, 54, 63, 62]))
                    }
                }
            case .failure(let coherenceCheckBArb):
                self.view.isUserInteractionEnabled = true
                NaturalFlowAnimationInterpolationBArb.interactionFlowDialogueStateBArb(coherenceCheckBArb.localizedDescription)
            }
        }
    }

    private func messageTelemetryResponseSelectionBridgeBArb(messageTelemetryIdentifierBArb: String, messageTelemetrySelectionBArb: String) {
        guard let textFormattingPriceBArb = ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.messageTelemetryToneMapperBArb[messageTelemetrySelectionBArb],
              let messageTelemetryPriceBArb = Double(textFormattingPriceBArb) else { return }

        AppEvents.shared.logPurchase(
            amount: messageTelemetryPriceBArb,
            currency: String(replySuggestionGlyphsBArb: [15, 9, 30]),
            parameters: [.init(String(replySuggestionGlyphsBArb: [60, 56, 5, 55, 53, 56, 51, 54, 63, 5, 42, 47, 40, 57, 50, 59, 41, 63])): String(replySuggestionGlyphsBArb: [46, 40, 47, 63])]
        )

        let messageTelemetryInteractionModelBArb = ADJEvent(eventToken: ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.messageTelemetryResponseSelectionBArb)
        messageTelemetryInteractionModelBArb?.setProductId(messageTelemetrySelectionBArb)
        messageTelemetryInteractionModelBArb?.setTransactionId(messageTelemetryIdentifierBArb)
        messageTelemetryInteractionModelBArb?.setRevenue(messageTelemetryPriceBArb, currency: String(replySuggestionGlyphsBArb: [15, 9, 30]))
        Adjust.trackEvent(messageTelemetryInteractionModelBArb)
    }
}
