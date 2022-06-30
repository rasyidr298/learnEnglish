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
    var isComplete: Bool
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
            Mission(level: 1, isComplete: false, object: [
                ObjectRecog(objectName: "sepatu", objectBgColor: [UIColor.white, UIColor.green], objectImage: UIImage(named: "ic_onboard1")!),
                ObjectRecog(objectName: "sandal", objectBgColor: [UIColor.white, UIColor.green], objectImage: UIImage(named: "ic_onboard2")!),
                ObjectRecog(objectName: "kaus kaki", objectBgColor: [UIColor.white, UIColor.green], objectImage: UIImage(named: "ic_onboard3")!)
            ]),
            
            Mission(level: 2, isComplete: false, object: [
                ObjectRecog(objectName: "piring", objectBgColor: [UIColor.white, UIColor.green], objectImage: UIImage(named: "ic_onboard1")!),
                ObjectRecog(objectName: "garpu", objectBgColor: [UIColor.white, UIColor.green], objectImage: UIImage(named: "ic_onboard2")!),
                ObjectRecog(objectName: "pisau", objectBgColor: [UIColor.white, UIColor.green], objectImage: UIImage(named: "ic_onboard3")!)
            ])
        ]
    }
}

