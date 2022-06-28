//
//  AppDelegate.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 21/06/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let showOnboarding = UserDefaults.standard.bool(forKey: showOnBoard)
        if !showOnboarding {
            window?.rootViewController = OnBoardingViewController()
        }else {
            window?.rootViewController = TabBarViewController()
        }
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
}


