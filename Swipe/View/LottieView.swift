//
//  LottieView.swift
//  Swipe
//
//  Created by Nafeez Ahmed on 18/11/24.
//

import SwiftUI
import Lottie


struct LottieView: UIViewRepresentable {
    let url: URL
   var animationView = LottieAnimationView()

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        animationView.animation = LottieAnimation.filepath(url.path)
        animationView.loopMode = .loop
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Play the animation if it's not already playing
        if !animationView.isAnimationPlaying {
            animationView.play()
        }
    }
}



