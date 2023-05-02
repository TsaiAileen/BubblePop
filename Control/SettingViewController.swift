//
//  SettingViewController.swift
//  Navigate
//
//  Created by Aileen Tsai on 10/4/2023.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var bubbleNumberSlider: UISlider!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            let VC = segue.destination as! GameViewController
            VC.playerName = nameTextField.text!
            VC.remainingTime = Int(timeSlider.value)
            VC.maxBubbleNumber = Int(bubbleNumberSlider.value)
        }
    }
}
