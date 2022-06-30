//
//  TabBarViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 25/06/22.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        self.delegate = delegate
        
        tabBar.backgroundColor = .secondarySystemBackground
        tabBar.tintColor = UIColor(named: "mainColor")
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //tab explore
        let tabExplore = TabExploreViewController()
        let tabExploreBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "globe"), selectedImage: UIImage(systemName: ""))
        tabExplore.tabBarItem = tabExploreBarItem
        
        //tab review
        let tabReview = TabReviewViewController()
        let tabReviewBarItem = UITabBarItem(title: "Review", image: UIImage(systemName: "star.bubble.fill"), selectedImage: UIImage(systemName: "star.bubble.fill"))
        tabReview.tabBarItem = tabReviewBarItem
        
        self.viewControllers = [tabExplore, tabReview]
    }

}
