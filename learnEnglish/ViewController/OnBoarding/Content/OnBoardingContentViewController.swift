//
//  OnBoardingContentViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 24/06/22.
//

import UIKit

class OnboardingContentViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var imgContent: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    var index = 0
    var heading = ""
    var subheading = ""
    var image = UIImage()
    var bgColor = UIColor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        imgContent.image = image
        headingLabel.text = heading
        subHeadingLabel.text = subheading
        nameTextField.delegate = self
        
        if heading == "" {
            nameTextField.isHidden = false
        }else {
            nameTextField.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}
