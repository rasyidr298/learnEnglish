//
//  TabBarViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 25/06/22.
//

import UIKit
import SwiftUI

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        self.delegate = delegate
        
        tabBar.backgroundColor = .systemGray5
        tabBar.tintColor = UIColor(named: "mainColor")
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //tab explore
        let tabExplore = TabExploreViewController()
        let tabExploreBarItem = UITabBarItem(title: "Explore", image: UIImage(named: "ic_explore"), selectedImage: UIImage(systemName: ""))
        tabExplore.tabBarItem = tabExploreBarItem
        
        //tab review
        let swiftUIController = UIHostingController(rootView: ReviewView())
//        let tabReview = TabReviewViewController()
        let tabReviewBarItem = UITabBarItem(title: "Review", image: UIImage(systemName: "star.bubble.fill"), selectedImage: UIImage(systemName: "star.bubble.fill"))
        swiftUIController.tabBarItem = tabReviewBarItem
        
        self.viewControllers = [tabExplore, swiftUIController]
    }

}
