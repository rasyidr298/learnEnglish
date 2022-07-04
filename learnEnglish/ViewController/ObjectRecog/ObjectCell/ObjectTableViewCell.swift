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
    
    public var object: [ObjectRecog]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupView() {
        bgView.layer.cornerRadius = 8
        containerView.layer.cornerRadius = 8
    }
    
    public func updateObjectCell(index: Int) {
        objectImg.image = object?[index].objectImage
        
//        if itemIsMatch {
//            bgView.backgroundColor = object[index].objectBgColor[1]
//        }else {
//            bgView.backgroundColor = object[index].objectBgColor[0]
//        }
    }
    
}
