//
//  OnBoardingPageViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 24/06/22.
//

import UIKit

protocol onboardingPageViewControllerDelegate: AnyObject {
    func setupPageController(numberOfPage: Int)
    func turnPageController(to index: Int)
}

class OnboardingPageViewController: UIPageViewController {
    
    weak var pageViewControllerDelegate: onboardingPageViewControllerDelegate?
    
    var pageTitle = ["Dear Parents", "Camera", "Report", ""]
    var pageDescriptionText = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ", ""]
    var pageImage: [UIImage] = [UIImage(named: "ic_onboard1")!, UIImage(named: "ic_onboard2")!, UIImage(named: "ic_onboard3")!, UIImage(named: "ic_onboard4")!, ]
    var backgroundColor: [UIColor] = [.white, .white, .white, .white]
    
    var currentIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
//        view.backgroundColor = .black
        
        dataSource = self
        delegate = self
        if let firstViewController = contentViewController(at: 0) {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if var index = (viewController as? OnboardingContentViewController)?.index {
            index -= 1
            return contentViewController(at: index)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if var index = (viewController as? OnboardingContentViewController)?.index {
            index += 1
            return contentViewController(at: index)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if let pageContentViewController = pageViewController.viewControllers?.first as? OnboardingContentViewController {
            currentIndex = pageContentViewController.index
            self.pageViewControllerDelegate?.turnPageController(to: currentIndex)
        }
    }
    
    func contentViewController(at index: Int) -> OnboardingContentViewController? {
        if index < 0 || index >= pageTitle.count {
            return nil
        }
        
        let pageContentViewController = OnboardingContentViewController(nibName: "OnBoardingContentViewController", bundle: nil)
        
        pageContentViewController.subheading = pageDescriptionText[index]
        pageContentViewController.heading = pageTitle[index]
        pageContentViewController.bgColor = backgroundColor[index]
        pageContentViewController.index = index
        pageContentViewController.image = pageImage[index]
        self.pageViewControllerDelegate?.setupPageController(numberOfPage: 3)
        
        return pageContentViewController
    }
}
