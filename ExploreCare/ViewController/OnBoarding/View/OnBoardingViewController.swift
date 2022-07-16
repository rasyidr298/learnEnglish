//
//  OnBoardingViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 24/06/22.
//

import UIKit

class OnBoardingViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var loginName: UITextField!
    
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
        loginName.isHidden = true
        loginName.delegate = self
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginName.resignFirstResponder()
        return true
    }
}

extension OnBoardingViewController {
    @IBAction func nextButton(_ sender: Any) {
        onBoardingPageViewController?.turnPage(index: pageControl.currentPage + 1, type: 1)
    }
    
    @IBAction func startButton(_ sender: Any) {
        
        if (loginName.text == "") {
            allert(view: self, title: "Allert", message: "name is required!")
        }else {
            UserDefaults.standard.set(true, forKey: showOnBoard)
            UserDefaults.standard.set(loginName.text, forKey: loginNameDef)

            guard let window = UIApplication.shared.keyWindow else {return}
            window.rootViewController = TabBarViewController()
        }
    }
}

extension OnBoardingViewController: OnboardingPageViewControllerDelegate {
    func setupPageController(numberOfPage: Int) {
        pageControl.numberOfPages = numberOfPage
    }
    
    func turnPageController(to index: Int) {
        pageControl.currentPage = index
        
        if index == 3 {
            startButton.isHidden = false
            nextButton.isHidden = true
            loginName.isHidden = false
        }else {
            startButton.isHidden = true
            nextButton.isHidden = false
            loginName.isHidden = true
        }
        
    }
}
