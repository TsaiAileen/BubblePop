//
//  Bubble.swift
//  Navigate
//
//  Created by Aileen Tsai on 10/4/2023.
//

import Foundation
import UIKit

class Bubble: UIButton {
    
    let xPosition = Int.random(in: 20...400)
    let yPosition = Int.random(in: 150...800)
    let colors = [
        (color: UIColor.red, score: 1, probability: 0.4),
        (color: UIColor.systemPink, score: 2, probability: 0.3),
        (color: UIColor.green, score: 5, probability: 0.15),
        (color: UIColor.blue, score: 8, probability: 0.1),
        (color: UIColor.black, score: 10, probability: 0.05)
    ]
    var color: UIColor = .red
    var score: Int = 0
    
    override init(frame: CGRect) {
        let random = Double.random(in: 0...1)
        var cumulativeProbability = 0.0
        for item in colors {
            cumulativeProbability += item.probability
            if random <= cumulativeProbability {
                self.color = item.color
                self.score = item.score
                break
            }
        }
        super.init(frame: frame)
        self.backgroundColor = self.color
        self.frame = CGRect(x: xPosition, y: yPosition, width: 50, height: 50)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Bubble appear animation
    func animation() {
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.duration = 0.6
        fadeAnimation.fromValue = 0
        fadeAnimation.toValue = 1
        fadeAnimation.repeatCount = 1
        
        layer.add(fadeAnimation, forKey: "opacityAnimation")
    }
}
