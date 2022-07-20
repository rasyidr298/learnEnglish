//
//  HapticsView.swift
//  ExploreCareW WatchKit Extension
//
//  Created by Rasyid Ridla on 19/07/22.
//

import Foundation
import SwiftUI


//testView
struct HapticsView: View {
    var body: some View {
        List {
            Button {
                WKInterfaceDevice.current().play(WKHapticType.notification)
            } label: {
                Text("notification")
            }
            Button {
                WKInterfaceDevice.current().play(WKHapticType.directionUp)
            } label: {
                Text("directionUp")
            }
            Button {
                WKInterfaceDevice.current().play(WKHapticType.directionDown)
            } label: {
                Text("directionDown")
            }
            Button {
                WKInterfaceDevice.current().play(WKHapticType.success)
            } label: {
                Text("success")
            }
            Button {
                WKInterfaceDevice.current().play(WKHapticType.failure)
            } label: {
                Text("failure")
            }
            Button {
                WKInterfaceDevice.current().play(WKHapticType.retry)
            } label: {
                Text("retry")
            }
            Button {
                WKInterfaceDevice.current().play(WKHapticType.start)
            } label: {
                Text("start")
            }
            Button {
                WKInterfaceDevice.current().play(WKHapticType.stop)
            } label: {
                Text("stop")
            }
            Button {
                WKInterfaceDevice.current().play(WKHapticType.click)
            } label: {
                Text("click")
            }
            //            Button {
            //                WKInterfaceDevice.current().play(WKHapticType.navigationLeftTurn)
            //            } label: {
            //                Text("navigationLeftTurn")
            //            }
            //            Button {
            //                WKInterfaceDevice.current().play(WKHapticType.navigationRightTurn)
            //            } label: {
            //                Text("navigationRightTurn")
            //            }
            //            Button {
            //                WKInterfaceDevice.current().play(WKHapticType.navigationGenericManeuver)
            //            } label: {
            //                Text("navigationGenericManeuver")
            //            }
            
        }
    }
}
