//
//  HapticsEngine.swift
//  ExploreCareW WatchKit Extension
//
//  Created by Rasyid Ridla on 20/07/22.
//

import Foundation
import SwiftUI


class TimerEngine: NSObject, ObservableObject {
    static let shared = TimerEngine()
    
    private var progressTimer: Timer?
    private var hapticTimer: Timer?
    private var muteTimer: Timer?
    
    private var session = WKExtendedRuntimeSession()
    
    //    private var isPlaying: Bool { progressTimer != nil }
    
    //init session
    private func startSessionIfNeeded() {
        //        guard !isPlaying, hapticSession.state != .running else { return }
        
        session = WKExtendedRuntimeSession()
        session.start()
    }
    
    //stop session
    //    private func stopSession() {
    //        session.invalidate()
    //    }
    
    //start tick
    private func tick(viewModel: MainViewModel) {
        
        //timer progress
        progressTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in
            viewModel.timeVal += 1
            
            //timer auto mute haptic
//            switch viewModel.timeVal {
//            case TimeMode.green: print("")
//            case TimeMode.yellow: print("")
//            case TimeMode.red: do {
//                do {
//                    // auto mute when > second
//                    if viewModel.isMute {
//                        self.muteTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in
//                            viewModel.timeMute += 1
//                            
//                            if viewModel.timeMute % 3 == 0 {
//                                viewModel.isMute.toggle()
//                            }
//                        }
//                    }else {
//                        viewModel.timeMute = 0
//                        self.stopPlayingTicks(type: 3)
//                        print(viewModel.timeMute)
//                    }
//                }
//            }
//            default: do {
//                // auto mute when > second
//                if viewModel.isMute {
//                    self.muteTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in
//                        viewModel.timeMute += 1
//                        
//                        if viewModel.timeMute % 3 == 0 {
//                            viewModel.isMute.toggle()
//                        }
//                    }
//                }else {
//                    viewModel.timeMute = 0
//                    self.stopPlayingTicks(type: 3)
//                    print(viewModel.timeMute)
//                }
//            }
//            }
        }
        
        
        //timer haptic
        hapticTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in
            switch viewModel.timeVal {
            case TimeMode.green: print("")
            case TimeMode.yellow: WKInterfaceDevice.current().play(.click)
            case TimeMode.red: WKInterfaceDevice.current().play(.directionUp)
            default: WKInterfaceDevice.current().play(.directionUp)
            }
        }
    }
    
    //start engine
    func startPlayinTicks(viewModel: MainViewModel) {
        progressTimer?.invalidate()
        progressTimer = nil
        
        hapticTimer?.invalidate()
        hapticTimer = nil
        
        muteTimer?.invalidate()
        muteTimer = nil
        
        startSessionIfNeeded()
        
        tick(viewModel: viewModel)
    }
    
    //stop enginge
    func stopPlayingTicks(type: Int) {
        switch type {
            
        case 1: do {
            hapticTimer?.invalidate()
            hapticTimer = nil
        }
            
        case 2: do {
            progressTimer?.invalidate()
            progressTimer = nil
        }
            
        case 3: do {
            muteTimer?.invalidate()
            muteTimer = nil
        }
            
        default: print("")
        }
        
        //        stopSession()
    }
}
