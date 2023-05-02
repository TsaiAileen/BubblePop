//
//  HighScoreViewController.swift
//  Navigate
//
//  Created by Aileen Tsai on 10/4/2023.
//

import Foundation
import UIKit

struct GameScore: Codable {
    var name: String
    var score: Int
}

let KEY_HIGH_SCORE = "highScore"

class HighScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var highScoreTableView: UITableView!
    
    var highScore: [GameScore] = []
    var playerName: String = ""
    var totalScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.highScore = readHighScore()
        highScore.sort {
            $0.score > $1.score
        }
        
        highScoreTableView.dataSource = self
        highScoreTableView.delegate = self
        
        // Add header view
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: highScoreTableView.frame.width, height: 50))
        headerView.backgroundColor = .darkGray
        let headerLabel = UILabel(frame: CGRect(x: 20, y: 0, width: highScoreTableView.frame.width - 40, height: 50))
        headerLabel.text = "Highest Ranking"
        // Chalkduster
        headerLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 30)
        headerLabel.textColor = .white
        headerLabel.textAlignment = .center
        headerView.addSubview(headerLabel)
        highScoreTableView.tableHeaderView = headerView
    }
    
    // When the player finish the game
    func saveHighScore(name: String, score: Int) {
        
        // Only save the score if it's greater than 0
        if score > 0 {
            var currentHighScores = readHighScore()
            
            let newScore = GameScore(name: name, score: score)
            currentHighScores.append(newScore)
            
            // Save to UserDefaults
            let defaults = UserDefaults.standard
            defaults.set(try! PropertyListEncoder().encode(currentHighScores), forKey: KEY_HIGH_SCORE)
        }
    }
    
    // When loading high score of the player
    func readHighScore() -> [GameScore] {
        let defaults = UserDefaults.standard
        if let savedData = defaults.value(forKey: KEY_HIGH_SCORE) as? Data {
            if let savedHighScore = try? PropertyListDecoder().decode(Array<GameScore>.self, from: savedData) {
                
                // Filter out players with a score of 0
                return savedHighScore.filter { $0.score > 20 }
            }
            return []
        }
        return []
    }
    
    // To set the data and customise it for the table view
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScore.count
    }
    
    // How the cell data will be customised
    @objc(tableView:cellForRowAtIndexPath:) internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let score = highScore[indexPath.row]
        cell.textLabel?.text = score.name
        cell.detailTextLabel?.text = "Score: \(score.score)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row < 3 else {
            return
        }
        
        // Set font size and weight for the first three rows
        let font: UIFont
        let color: UIColor
        
        switch indexPath.row {
        case 0:
            font = UIFont(name: "ArialRoundedMTBold", size: 28)!
            color = .systemRed
        case 1:
            font = UIFont(name: "ArialRoundedMTBold", size: 24)!
            color = .systemYellow
        case 2:
            font = UIFont(name: "ArialRoundedMTBold", size: 20)!
            color = .systemTeal
        default:
            font = UIFont(name: "ArialRoundedMTBold", size: 16)!
            color = .black
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color
        ]
        
        let playerName = highScore[indexPath.row].name
        let attributedString = NSAttributedString(string: playerName, attributes: attributes)
        
        cell.textLabel?.attributedText = attributedString
    }
    
    @IBAction func returnToMainPage(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
