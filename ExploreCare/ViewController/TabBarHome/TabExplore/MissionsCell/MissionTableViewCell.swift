//
//  MissionTableViewCell.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 29/06/22.
//

import UIKit

class MissionTableViewCell: UITableViewCell {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var countObjectLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var levelUnlockLabel: UILabel!
    @IBOutlet weak var levelBgView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var objectImage1: UIImageView!
    @IBOutlet weak var objectImage2: UIImageView!
    @IBOutlet weak var objectImage3: UIImageView!
    @IBOutlet weak var objectImage4: UIImageView!
    @IBOutlet weak var objectImage5: UIImageView!
    
    public var missions: Mission?
    
    private var  viewModel = ObjectRecogViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    @IBAction func playButton(_ sender: Any) {
        guard let window = UIApplication.shared.keyWindow else {return}
        let vc = ObjectRecogViewController()
        vc.mission = self.missions
        window.rootViewController = vc
        
        //push data to watch
        let name = UserDefaults.standard.string(forKey: loginNameDef)
        viewModel.sendMessageToIwatch(name: name, time: 0, startExplore: true)
    }
    
    private func setupView() {
        levelBgView.layer.cornerRadius = 4
        playButton.layer.cornerRadius = 8
        containerView.map { cont in
            cont.layer.cornerRadius = 8
            cont.backgroundColor = .secondarySystemBackground
        }
    }
    
    public func updateMissionsCell() {
        levelLabel.text = "Level \(self.missions?.level ?? 1)"
        countObjectLabel.text = "\(self.missions?.object.count ?? 1) Item to find"
        
        objectImage1.image = missions?.object[0].objectImage
        objectImage2.image = missions?.object[1].objectImage
        objectImage3.image = missions?.object[2].objectImage
        
        if missions?.object.count ?? 3 > 3 {
            objectImage4.image = missions?.object[3].objectImage
            objectImage5.image = missions?.object[4].objectImage
        }
        
        if missions!.isLockLevel {
            levelUnlockLabel.text = "Level Lock"
        }else {
            levelUnlockLabel.text = "Level Unlock"
        }
    }
    
}
