//
//  Logger.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 30/06/22.
//

import Foundation

enum LogType: String{
    case error
    case warning
    case success
    case action
    case canceled
}


class Logger{

 static func log(_ logType:LogType,_ message:String){
        switch logType {
        case LogType.error:
            print("\nš Error: \(message)\n")
        case LogType.warning:
            print("\nš Warning: \(message)\n")
        case LogType.success:
            print("\nš Success: \(message)\n")
        case LogType.action:
            print("\nš Action: \(message)\n")
        case LogType.canceled:
            print("\nš Cancelled: \(message)\n")
        }
    }

}
