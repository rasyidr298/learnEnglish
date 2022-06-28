//
//  TabExploreViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 25/06/22.
//

import UIKit

class TabExploreViewController: UIViewController {

    @IBOutlet weak var lvButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func lvButton(_ sender: Any) {
        guard let window = UIApplication.shared.keyWindow else {return}
        window.rootViewController = ObjectRecogViewController()
    }
    
}
