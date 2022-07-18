//
//  ContentView.swift
//  ExploreCareW WatchKit Extension
//
//  Created by Rasyid Ridla on 14/07/22.
//

import SwiftUI

struct MainView: View {
    let screenSize = WKInterfaceDevice.current().screenBounds.size
    
    @State var timerVal = 1
    @State var isMute = false
    
    var body: some View {
        if timerVal > 0 {
            ZStack {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Image(systemName: isMute ? "speaker.wave.2" : "speaker.slash")
                            .frame(width: 39, height: 39, alignment: .center)
                    }
                }
                VStack {
                    Text("Rachel Is \n Exploring")
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.center)
                    ZStack {
                        Rectangle()
                            .frame(width: 40, height: 15, alignment: .center)
                            .cornerRadius(5)
                            .foregroundColor(Color.green)
                        Text(timeString(time: timerVal))
                            .font(.system(size: 9, weight: .bold, design: .serif))
                    }
                }
                PercentageRing(
                    ringWidth: 20, percent: Double(timerVal) ,
                    backgroundColor: Color.green.opacity(0.2),
                    foregroundColors: [.green, .blue]
                )
                .frame(width: screenSize.width - 22, height: screenSize.height - 22)
                .onAppear() {
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                        if timerVal > 0 {
                            timerVal += 1
                        }
                    }
                }
            }
        }
    }
}


//int timer to date
public func timeString(time: Int) -> String {
//    let hours   = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
//    return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    return String(format:"%02i:%02i", minutes, seconds)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
