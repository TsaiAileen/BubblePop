//
//  GameViewController.swift
//  Navigate
//
//  Created by Aileen Tsai on 10/4/2023.
//

import Foundation
import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var playerName: String = ""
    var remainingTime = 60
    var timer: Timer?
    var playerScore = 0
    var bubbles = [Bubble]()
    var maxBubbleNumber = 15
    var score: Int = 0
    var totalScore: Int = 0
    var lastColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = playerName
        remainingTimeLabel.text = String(remainingTime)
        scoreLabel.text = "0"
        
        // Count down game time
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.counting()
            self.generateBubble()
            self.removeAndReplaceBubbles()
        }
    }
    
    func counting() {
        remainingTime -= 1
        remainingTimeLabel.text = String(remainingTime)
        
        // Action when time ends
        if remainingTime == 0 {
            timer?.invalidate()
            
            // Show high score screen
            let vc = storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
            
            vc.playerName = playerName
            vc.totalScore = totalScore
            
            navigationController?.pushViewController(vc, animated: true)
            vc.navigationItem.setHidesBackButton(true, animated: true)
            
            // Save the high score in HighScoreViewController
            vc.saveHighScore(name: playerName, score: totalScore)
        }
        
    }
    
    func generateBubble() {
        
        // Generate a random number between 1 and 15
        let maxBubblesPerGeneration = Int.random(in: 1...15)
        let remainingBubbles = maxBubbleNumber - bubbles.count
        let numBubblesToGenerate = min(maxBubblesPerGeneration, remainingBubbles)
        
        for _ in 0..<numBubblesToGenerate {
        let bubble = Bubble()
        
        var isOverlap = false
        
        // Limit the number of attempts to avoid infinite loops
        var attempts = 0
        
            repeat {
                bubble.animation()
                
                // Set the minimum y value for the bubble to the bottom of the score label
                let minY = scoreLabel.frame.maxY
                
                // Randomize the x value within the screen width
                let maxX = view.frame.width - bubble.frame.width
                let randomX = CGFloat.random(in: 0...maxX)
                
                // Set the bubble frame with the randomized x value and the minimum y value
                bubble.frame.origin = CGPoint(x: randomX, y: minY)
                
                // Add the new bubble to the view
                bubble.addTarget(self, action: #selector(bubblePressed(_:)), for: .touchUpInside)
                self.view.addSubview(bubble)
                
                // Check for overlap with existing bubbles
                isOverlap = false
                for existingBubble in bubbles {
                    if bubble.frame.intersects(existingBubble.frame) {
                        isOverlap = true
                        break
                    }
                }
                
                // If there is an overlap, remove the bubble and try again
                if isOverlap {
                    bubble.removeFromSuperview()
                    attempts += 1
                }
                
            // Adjust the number of attempts if necessary
            } while isOverlap && attempts < 30
            
            // If a valid position is found, append the bubble to the bubbles array
            if !isOverlap {
                self.bubbles.append(bubble)
            }
        }
    }
    
    // When bubble pressed
    @objc func bubblePressed(_ sender: Bubble) {
        if let lastColor = self.lastColor, lastColor == sender.color {
            score += Int(Double(sender.score) * 1.5)
            totalScore += Int(Double(sender.score) * 1.5)
        } else {
            score += sender.score
            totalScore += sender.score
        }
        scoreLabel.text = "\(totalScore)"
        _ = Bubble()
        UIView.animate(withDuration: 0.3, animations: {
                sender.alpha = 0
                sender.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        }, completion: { _ in
            sender.removeFromSuperview()
            self.bubbles.removeAll(where: {$0 == sender})
            self.lastColor = sender.color
        })
    }
    
    // Remove and replace bubbles
    func removeAndReplaceBubbles() {
        let removeCount = Int.random(in: 0..<self.bubbles.count)
        var indexesToRemove = Set<Int>()
        
        // Find indexes of bubbles to remove
        while indexesToRemove.count < removeCount {
            let randomIndex = Int.random(in: 0..<self.bubbles.count)
            indexesToRemove.insert(randomIndex)
        }
        
        // Remove bubbles at selected indexes
        for index in indexesToRemove.sorted().reversed() {
            if index < self.bubbles.count {
                let bubbleToRemove = self.bubbles[index]
                bubbleToRemove.removeFromSuperview()
                self.bubbles.remove(at: index)
            }
        }
        
        for _ in 0..<removeCount {
            let bubble = Bubble()
            bubble.animation()
            
            // Add the new bubble to the view screen
            bubble.addTarget(self, action: #selector(bubblePressed(_:)), for: .touchUpInside)
            self.view.addSubview(bubble)
            self.bubbles.append(bubble)
        }
    }
    
}
