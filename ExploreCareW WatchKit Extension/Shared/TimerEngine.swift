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
    
    private var session = WKExtendedRuntimeSession()
    
    //start tick
    private func tick(viewModel: MainViewModel) {
        
        //timer haptic
        hapticTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in
            if !viewModel.isMute {
                switch viewModel.timeVal {
                case TimeMode.stanby: print("")
                case TimeMode.green: print("")
                case TimeMode.yellow: WKInterfaceDevice.current().play(.click)
                case TimeMode.red: WKInterfaceDevice.current().play(.directionUp)
                default: WKInterfaceDevice.current().play(.directionUp)
                }
            }
        }
        
        //timer progress
        progressTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in
            
            //testing
            viewModel.timeVal += 30
            
            //fix
//            viewModel.timeVal += 1
            
            if viewModel.isMute {
                //timer auto mute haptic
                switch viewModel.timeVal {
                case TimeMode.stanby: print("")
                case TimeMode.green: print("")
                case TimeMode.yellow :print("")
                case TimeMode.red: do {
                    if viewModel.timeVal % 60 == 0 {
                        viewModel.isMute.toggle()
                    }
                }
                default: do {
                    if viewModel.timeVal % 60 == 0 {
                        viewModel.isMute.toggle()
                    }
                }
                }
            }
        }
    }
    
    //start engine
    func startPlayinTicks(viewModel: MainViewModel) {
        
//        startSessionIfNeeded()
        
        progressTimer?.invalidate()
        progressTimer = nil
        
        hapticTimer?.invalidate()
        hapticTimer = nil
        
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
            
        default: print("")
        }
    }
}
