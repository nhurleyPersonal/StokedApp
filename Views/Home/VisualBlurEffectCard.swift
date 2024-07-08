//
//  VisualBlurEffectCard.swift
//  Stoked
//
//  Created by Noah Hurley on 7/5/24.
//

import SwiftUI

struct VisualEffectBlurCard: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    var vibrancyStyle: UIVibrancyEffectStyle?

    func makeUIView(context _: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: blurStyle)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)

        if let vibrancyStyle = vibrancyStyle {
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: vibrancyStyle)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            vibrancyView.frame = visualEffectView.contentView.bounds
            vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            visualEffectView.contentView.addSubview(vibrancyView)
        }

        return visualEffectView
    }

    func updateUIView(_: UIVisualEffectView, context _: Context) {
        // No need to update the view as the effect doesn't change
    }
}

// #Preview {
//     VisualEffectBlur(blurStyle: .systemMaterial)
// }
