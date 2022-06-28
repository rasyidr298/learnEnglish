//
//  Object.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 26/06/22.
//

import Foundation
import UIKit

struct Object {
    var objectName: String
    var objectBgColor: [UIColor]
    var objectImage: UIImage
}

extension Object {
    static func dataObject() -> [Object] {
        return [
            Object(objectName: "home", objectBgColor: [.white, .green], objectImage: UIImage(named: "ic_onboard1")!),
            Object(objectName: "home", objectBgColor: [.white, .green], objectImage: UIImage(named: "ic_onboard2")!),
            Object(objectName: "home", objectBgColor: [.white, .green], objectImage: UIImage(named: "ic_onboard3")!)]
    }
}


