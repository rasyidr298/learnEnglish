//
//  OnBoardingViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 24/06/22.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var onBoardingPageViewController: OnboardingPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupPageView()
        setupView()
    }
    
    private func setupView() {
        startButton.layer.cornerRadius = 10
    }
    
    private func setupPageView() {
        onBoardingPageViewController = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        addChild(onBoardingPageViewController!)
        containerView.addSubview((onBoardingPageViewController?.view)!)
        onBoardingPageViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            onBoardingPageViewController!.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            onBoardingPageViewController!.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            onBoardingPageViewController!.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            onBoardingPageViewController!.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        onBoardingPageViewController?.didMove(toParent: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onBoardingViewController = segue.destination as? OnboardingPageViewController {
            onBoardingViewController.pageViewControllerDelegate = self
            onBoardingPageViewController = onBoardingViewController
        }
    }
}

extension OnBoardingViewController {
    
    @IBAction func skipButton(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: showOnBoard)
        guard let window = UIApplication.shared.keyWindow else {return}
        window.rootViewController = TabBarViewController()
        
        
//        let vc = TabBarViewController()
//        let navCon = UINavigationController(rootViewController: vc)
//        navCon.modalPresentationStyle = .fullScreen
//        present(navCon, animated: false)
    }
    
    @IBAction func startButton(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: showOnBoard)
        guard let window = UIApplication.shared.keyWindow else {return}
        window.rootViewController = TabBarViewController()
    }
}

extension OnBoardingViewController: onboardingPageViewControllerDelegate {
    func setupPageController(numberOfPage: Int) {
        pageControl.numberOfPages = numberOfPage
    }
    
    func turnPageController(to index: Int) {
        pageControl.currentPage = index
        
        if index == 2 {
            skipButton.isHidden = true
        }else {
            skipButton.isHidden = false
        }
        
        if index == 2 {
            startButton.isHidden = false
        }else {
            startButton.isHidden = true
        }
        
    }
}
