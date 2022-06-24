//
//  Haptics.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 24/06/22.
//

import Foundation
import UIKit

func hapticButton(type: Int) {
    switch type {
        case 1:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)

        case 2:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)

        case 3:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)

        case 4:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()

        case 5:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()

        case 6:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()

        default:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
    }
}
