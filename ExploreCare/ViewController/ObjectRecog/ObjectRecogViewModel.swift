//
//  ObjectRecogViewMode.swift
//  ExploreCare
//
//  Created by Rasyid Ridla on 20/07/22.
//

import Foundation
import WatchConnectivity

class ObjectRecogViewModel: NSObject, WCSessionDelegate {
    
    var wcSession: WCSession
    
    init(session: WCSession = .default) {
        wcSession = session
        super.init()
        wcSession.delegate = self
        wcSession.activate()
    }
    
    public func sendMessageToIwatch(name: String?, time: Int, startExplore: Bool) {
        self.wcSession.sendMessage(["name": name ?? ""], replyHandler: nil)
        self.wcSession.sendMessage(["timer": time], replyHandler: nil)
        self.wcSession.sendMessage(["start": startExplore], replyHandler: nil)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
}
