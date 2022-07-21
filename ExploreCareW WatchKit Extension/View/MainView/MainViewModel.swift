//
//  File.swift
//  ExploreCareW WatchKit Extension
//
//  Created by Rasyid Ridla on 19/07/22.
//

import Foundation
import WatchConnectivity
import SwiftUI
//import Combine

class MainViewModel: NSObject, ObservableObject, WCSessionDelegate, WKExtendedRuntimeSessionDelegate {
    
    var wcSession: WCSession
    let weSession: WKExtendedRuntimeSession
    
    @Published var name = ""
    @Published var isMute = false
    @Published var timeVal = 0
    
    @Published var isStartExplore = false{
        didSet {
            objectWillChange.send()
        }
    }
    
    init(session: WCSession = .default) {
        self.wcSession = session
        self.weSession = WKExtendedRuntimeSession()
        super.init()
        
        weSession.delegate = self
        wcSession.delegate = self
        
        wcSession.activate()
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async { [self] in
            if self.name == "" {
                self.name = message["name"] as? String ?? ""
            }
            self.timeVal = message["timer"] as? Int ?? 0
            self.isStartExplore = message["start"] as? Bool ?? false
            
            print("name vm : ", name)
            print("isStartExplore vm : ", isStartExplore)
        }
    }
    
    
    //wesession
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    
    //weSession
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        extendedRuntimeSession.start()
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        extendedRuntimeSession.start()
    }
}
