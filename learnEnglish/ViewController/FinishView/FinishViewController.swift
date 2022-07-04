//
//  FinishViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 03/07/22.
//

import UIKit

class FinishViewController: UIViewController {

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    public var mission: Mission?
    
    public var level = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        AppUtility.lockOrientation(.landscapeRight)
        finishButton.layer.cornerRadius = 8
        playAgainButton.layer.cornerRadius = 8
        descLabel.text = "You’ve complate level \(level), let’s find more, keep it up 💪"
    }
    
    @IBAction func playAgainButton(_ sender: Any) {
        guard let window = UIApplication.shared.keyWindow else {return}
        let vc = ObjectRecogViewController()
        vc.mission = self.mission
        window.rootViewController = vc
    }
    
    @IBAction func finishButton(_ sender: Any) {
        guard let window = UIApplication.shared.keyWindow else {return}
        window.rootViewController = TabBarViewController()
    }
}
