//
//  Missions.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 29/06/22.
//

import Foundation
import UIKit

struct Mission {
    var level: Int
    var isLockLevel: Bool
    var object: [ObjectRecog]
}


struct ObjectRecog {
    var objectName: String
    var objectBgColor: [UIColor]
    var objectImage: UIImage
}


//dummy data
extension Mission {
    static func dataObject() -> [Mission] {
        return [
            Mission(level: 1, isLockLevel: false, object: [
                ObjectRecog(objectName: "backpack", objectBgColor: [UIColor.white, UIColor.green], objectImage: UIImage(named: "ic_backpack")!),
                ObjectRecog(objectName: "tvmonitor", objectBgColor: [UIColor.white, UIColor.green], objectImage: UIImage(named: "ic_tv")!),
                ObjectRecog(objectName: "clock", objectBgColor: [UIColor.white, UIColor.green], objectImage: UIImage(named: "ic_clock")!)
            ]),
            
            Mission(level: 2, isLockLevel: false, object: [
                ObjectRecog(objectName: "book", objectBgColor: [UIColor.white, UIColor.green], objectImage: UIImage(named: "ic_book")!),
                ObjectRecog(objectName: "laptop", objectBgColor: [UIColor.white, UIColor.green], objectImage: UIImage(named: "ic_laptop")!),
                ObjectRecog(objectName: "cup", objectBgColor: [UIColor.white, UIColor.green], objectImage: UIImage(named: "ic_cup")!)
            ])
        ]
    }
}

