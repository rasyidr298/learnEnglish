//
//  File.swift
//  ExploreCareW WatchKit Extension
//
//  Created by Rasyid Ridla on 19/07/22.
//

import Foundation
import WatchConnectivity
//import Combine

class MainViewModel: NSObject, ObservableObject, WCSessionDelegate {
    
    var wcSession: WCSession
    
    @Published var name = ""
    @Published var isMute = false
    @Published var timeVal = 0
    
    @Published var isStartExplore = false{
        didSet {
            objectWillChange.send()
        }
    }
    
    init(session: WCSession = .default) {
        wcSession = session
        super.init()
        wcSession.delegate = self
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
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
