//
//  ObjectTableViewCell.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 25/06/22.
//

import UIKit

class ObjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var objectImg: UIImageView!
    
    public var object: [ObjectRecog]?
    
    override func layoutSubviews() {
        super.layoutSubviews()
            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0.0, bottom: 5, right: 0.0))
    }
    
    public func updateObjectCell(index: Int) {
        objectImg.image = object?[index].objectImage
    }
    
}
