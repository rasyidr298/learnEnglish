//
//  View.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 30/06/22.
//

import Foundation
import UIKit
import AVFoundation

func allert(view: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
    view.present(alert, animated: true, completion: nil)
}
