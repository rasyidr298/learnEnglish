//
//  ContentView.swift
//  ExploreCareW WatchKit Extension
//
//  Created by Rasyid Ridla on 14/07/22.
//

import SwiftUI

struct MainView: View {
    let screenSize = WKInterfaceDevice.current().screenBounds.size
    
    @State var user = "Rachel"
    @State var timerVal = 1
    @State var isMute = false
    
    var body: some View {
        if timerVal > 0 {
            ZStack {
                if timerVal >= 7 {
                    SoundButton(isMute: isMute)
                        .onAppear() {
                            if timerVal >= 7 {
//                                AVService.shared.player?.numberOfLoops = 10
                                AVService.shared.playMusic()
                            }
                        }
                }
                VStack {
                    Text("\(user) Is \n Exploring")
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.center)
                    ZStack {
                        Rectangle()
                            .frame(width: 40, height: 15, alignment: .center)
                            .cornerRadius(5)
                            .foregroundColor(ringColor(time: timerVal).1.last)
                        Text(timeString(time: timerVal))
                            .font(.system(size: 9, weight: .bold, design: .serif))
                    }
                }
                PercentageRing(
                    ringInnerWidth: 20, ringWidth: 23, percent: Double(timerVal) ,
                    backgroundColor: ringColor(time: timerVal).0,
                    foregroundColors: ringColor(time: timerVal).1
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

enum TimeMode {
    static let green = 0...3
    static let yellow = 4...6
    static let red = 7...9
    case outOfRange
}

//soundButton
struct SoundButton: View {
    @State var isMute: Bool
    
    var body: some View {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Image(systemName: isMute ? "speaker.slash" : "speaker.wave.2")
                        .frame(width: 39, height: 39, alignment: .center)
                        .onTapGesture {
                            isMute.toggle()
                            if isMute {
                                AVService.shared.player?.stop()
                            }else {
                                AVService.shared.playMusic()
                            }
                        }
                }
            }
    }
}


//ringcolor
func ringColor(time: Int) -> (Color, [Color]) {
    switch time {
    case TimeMode.green: return (Color.green.opacity(0.2), [Color.green.opacity(0.4), Color.green])
    case TimeMode.yellow: return (Color.yellow.opacity(0.2), [Color.yellow.opacity(0.4), Color.yellow])
    case TimeMode.red: return (Color.red.opacity(0.2), [Color.red.opacity(0.4), Color.red])
    default:
        return (Color.green.opacity(0.2), [Color.green.opacity(0.4), Color.green])
    }
}

//int timer to date
func timeString(time: Int) -> String {
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
