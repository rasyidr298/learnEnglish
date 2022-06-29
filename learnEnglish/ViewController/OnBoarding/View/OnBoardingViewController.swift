//
//  OnBoardingViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 24/06/22.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var onBoardingPageViewController: OnboardingPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupPageView()
        setupView()
    }
    
    private func setupView() {
        startButton.layer.cornerRadius = 10
        nextButton.layer.cornerRadius = 10
        startButton.isHidden = true
    }
    
    private func setupPageView() {
        onBoardingPageViewController = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        onBoardingPageViewController?.pageViewControllerDelegate = self
        
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
    
    @IBAction func nextButton(_ sender: Any) {
                onBoardingPageViewController?.turnPage(index: pageControl.currentPage + 1, type: 1)    }
    
    @IBAction func startButton(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: showOnBoard)
        guard let window = UIApplication.shared.keyWindow else {return}
        window.rootViewController = TabBarViewController()
        
        //        let vc = TabBarViewController()
        //        let navCon = UINavigationController(rootViewController: vc)
        //        navCon.modalPresentationStyle = .fullScreen
        //        present(navCon, animated: false)
    }
}

extension OnBoardingViewController: onboardingPageViewControllerDelegate {
    func setupPageController(numberOfPage: Int) {
        pageControl.numberOfPages = numberOfPage
    }
    
    func turnPageController(to index: Int) {
        pageControl.currentPage = index
        
        if index == 3 {
            startButton.isHidden = false
            nextButton.isHidden = true
        }else {
            startButton.isHidden = true
            nextButton.isHidden = false
        }
        
    }
}
