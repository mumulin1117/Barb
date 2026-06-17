import AdjustSdk
import FBSDKCoreKit
import Foundation
import UIKit

extension PhraseSynthesisRootViewControllerBArb {
    func messageTelemetryPurchaseStartBridgeBArb(lexicalRetrievalContextBArb: [String: Any]) {
        let messageTelemetrySelectionBArb = lexicalRetrievalContextBArb[ReplySuggestionLexicalGraphBArb.dialogueGraphBatchConstraintsBArb] as? String ?? ""
        let responseSelectionBArb = lexicalRetrievalContextBArb[ReplySuggestionLexicalGraphBArb.dialogueGraphResponseSelectionBArb] as? String ?? ""
        view.isUserInteractionEnabled = false
        NaturalFlowAnimationInterpolationBArb.interactionFlowNaturalFlowBArb(ReplySuggestionLexicalGraphBArb.messageTelemetryNaturalFlowTextBArb)

        AiQuickReplyMessageTelemetryBArb.messageTelemetryBArb.messageTelemetryPurchaseStartBArb(messageTelemetrySelectionBArb: messageTelemetrySelectionBArb) { [weak self] responseSelectionResultBArb in
            guard let self else { return }
            NaturalFlowAnimationInterpolationBArb.interactionFlowPruningBArb()
            self.view.isUserInteractionEnabled = true
            switch responseSelectionResultBArb {
            case .success:
                guard let semanticValidatorBArb = AiQuickReplyMessageTelemetryBArb.messageTelemetryBArb.semanticValidatorReceiptDataBArb(),
                      let messageTelemetryIdentifierBArb = AiQuickReplyMessageTelemetryBArb.messageTelemetryBArb.messageTelemetryIdentifierBArb,
                      let textTokenizationPayloadBArb = try? JSONSerialization.data(withJSONObject: [ReplySuggestionLexicalGraphBArb.dialogueGraphResponseSelectionBArb: responseSelectionBArb], options: [.prettyPrinted]),
                      let adaptiveTextPayloadBArb = String(data: textTokenizationPayloadBArb, encoding: .utf8) else {
                    NaturalFlowAnimationInterpolationBArb.interactionFlowDialogueStateBArb(ReplySuggestionLexicalGraphBArb.messageTelemetrySemanticPruningBArb)
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
                        NaturalFlowAnimationInterpolationBArb.interactionFlowContextValidationBArb(ReplySuggestionLexicalGraphBArb.messageTelemetryInteractionFlowBArb)
                    case .failure:
                        NaturalFlowAnimationInterpolationBArb.interactionFlowDialogueStateBArb(ReplySuggestionLexicalGraphBArb.messageTelemetrySemanticPruningBArb)
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
            currency: ReplySuggestionLexicalGraphBArb.messageTelemetryDictionEnhancementBArb,
            parameters: [.init(ReplySuggestionLexicalGraphBArb.messageTelemetryRhetoricalDeviceBArb): ReplySuggestionLexicalGraphBArb.contextValidationNuanceAlignmentBArb]
        )

        let messageTelemetryInteractionModelBArb = ADJEvent(eventToken: ConversationalCohesionSemanticLayerBArb.conversationalCohesionBArb.messageTelemetryResponseSelectionBArb)
        messageTelemetryInteractionModelBArb?.setProductId(messageTelemetrySelectionBArb)
        messageTelemetryInteractionModelBArb?.setTransactionId(messageTelemetryIdentifierBArb)
        messageTelemetryInteractionModelBArb?.setRevenue(messageTelemetryPriceBArb, currency: ReplySuggestionLexicalGraphBArb.messageTelemetryDictionEnhancementBArb)
        Adjust.trackEvent(messageTelemetryInteractionModelBArb)
    }
}
