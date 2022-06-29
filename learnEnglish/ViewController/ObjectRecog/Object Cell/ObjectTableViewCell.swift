//
//  ObjectTableViewCell.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 25/06/22.
//

import UIKit

class ObjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var objectImg: UIImageView!
    
    var object: Object?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupView() {
        bgView.layer.cornerRadius = 8
        containerView.layer.cornerRadius = 8
//        containerView.isHidden = true
    }
    
    func updateObjectCell(itemIsMatch: Bool) {
        objectImg.image = object?.objectImage
        if itemIsMatch {
            bgView.backgroundColor = object?.objectBgColor[1]
        }else {
            bgView.backgroundColor = object?.objectBgColor[0]
        }
    }
    
}
