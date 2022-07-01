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
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var objectImage1: UIImageView!
    @IBOutlet weak var objectImage2: UIImageView!
    @IBOutlet weak var objectImage3: UIImageView!
    @IBOutlet weak var objectImage4: UIImageView!
    @IBOutlet weak var objectImage5: UIImageView!
    
    var missions: Mission?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    @IBAction func playButton(_ sender: Any) {
        guard let window = UIApplication.shared.keyWindow else {return}
        let vc = ObjectRecogViewController()
        vc.mission = self.missions
        window.rootViewController = vc
        
        
//        let vc = ObjectRecogViewController()
//        let navCon = UINavigationController(rootViewController: vc)
//        navCon.modalPresentationStyle = .fullScreen
//        present(navCon, animated: false)
        
//        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
//            navigationController.present(ObjectRecogViewController(), animated: false)
//            navigationController.viewControllers.last as! TabBarViewController
//        }
    }
    
    func setupView() {
        playButton.layer.cornerRadius = 8
        containerView.map { cont in
            cont.layer.cornerRadius = 8
            cont.backgroundColor = .secondarySystemBackground
        }
    }
    
    func updateMissionsCell() {
        levelLabel.text = "Level \(self.missions?.level ?? 1)"
        countObjectLabel.text = "\(self.missions?.object.count ?? 1) Item to find"
        
        objectImage1.image = missions?.object[0].objectImage
        objectImage2.image = missions?.object[1].objectImage
        objectImage3.image = missions?.object[2].objectImage
        
        if missions?.object.count ?? 3 > 3 {
            objectImage4.image = missions?.object[3].objectImage
            objectImage5.image = missions?.object[4].objectImage
        }
        
        
        if ((missions?.isComplete) != nil) {
            badgeImage.image = UIImage(systemName: "checkmark.circle.fill")
        }else {
            badgeImage.image = UIImage(systemName: "x.circle.fill")
        }
        
        
    }
    
}
