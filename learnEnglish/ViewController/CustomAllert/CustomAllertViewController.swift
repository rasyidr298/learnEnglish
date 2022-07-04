//
//  CustomAllertViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 04/07/22.
//

import UIKit

protocol CustomAlertDelegate: class {
    func onPositiveButttonPressed(_ alert: CustomAllertViewController, indexObject: Int)
    func onNegativeButtonPressed(_ alert: CustomAllertViewController, indexObject: Int)
}

class CustomAllertViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var objectImage: UIImageView!
    @IBOutlet weak var objectNameLabel: UILabel!
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var positiveButton: UIButton!
    
    var allertTitle = ""
    var allertPositiveButtonTitle = "Ok"
    var allertNegativeButtonTitle = "Cancel"
    var allertImage = UIImage.init(named: "ic_cup")
    var indexObject = 0
    
    weak var delegate: CustomAlertDelegate?

    init() {
        super.init(nibName: "CustomAllertViewController", bundle: Bundle(for: CustomAllertViewController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func show() {
        if #available(iOS 13, *) {
            UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
        } else {
            UIApplication.shared.keyWindow?.rootViewController!.present(self, animated: true, completion: nil)
        }
    }
    
    @IBAction func positiveButton(_ sender: Any) {
        delegate?.onPositiveButttonPressed(self, indexObject: indexObject)
    }
    
    @IBAction func negativeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.onNegativeButtonPressed(self, indexObject: indexObject)
    }

    func setupView() {
        AppUtility.lockOrientation(.landscapeRight)
        containerView.layer.cornerRadius = 12
        objectNameLabel.text = allertTitle
        objectImage.image = allertImage
        positiveButton.setTitle(allertPositiveButtonTitle, for: .normal)
        negativeButton.setTitle(allertNegativeButtonTitle, for: .normal)
    }

}
