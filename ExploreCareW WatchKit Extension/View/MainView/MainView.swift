//
//  ContentView.swift
//  ExploreCareW WatchKit Extension
//
//  Created by Rasyid Ridla on 14/07/22.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel = MainViewModel()
    
    var body: some View {
        WatchView(viewModel: viewModel)
    }
}

//watchView
struct WatchView: View {
    let screenSize = WKInterfaceDevice.current().screenBounds.size
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        if viewModel.timeVal > 0 {
            ZStack {
                soundMode(viewModel: viewModel)
                VStack {
                    Text("\(viewModel.name) Is \n Exploring")
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.center)
                    ZStack {
                        Rectangle()
                            .frame(width: 40, height: 15, alignment: .center)
                            .cornerRadius(5)
                            .foregroundColor(ringColor(time: viewModel.timeVal).1.last)
                        Text(timeString(time: viewModel.timeVal))
                            .font(.system(size: 9, weight: .bold, design: .serif))
                    }
                }
                PercentageRing(
                    ringInnerWidth: 20, ringWidth: 23, percent: Double(viewModel.timeVal) ,
                    backgroundColor: ringColor(time: viewModel.timeVal).0,
                    foregroundColors: ringColor(time: viewModel.timeVal).1
                )
                .frame(width: screenSize.width - 22, height: screenSize.height - 22)
                .onAppear() {
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                        if viewModel.timeVal > 0 {
                            viewModel.timeVal += 1
                        }
                    }
                }
            }
        }
    }
}


//soundButton
struct SoundButton: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Image(systemName: viewModel.isMute ? "speaker.slash" : "speaker.wave.2")
                    .frame(width: 39, height: 39, alignment: .center)
                    .onTapGesture {
                        viewModel.isMute.toggle()
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

//soundMode
func soundMode(viewModel: MainViewModel) -> AnyView? {
    switch viewModel.timeVal {
    case TimeMode.green: print("")
    case TimeMode.yellow: watchHaptic(type: 1)
    case TimeMode.red: do {
        if viewModel.isMute {
            watchHaptic(type: 3)
        }else {
            watchHaptic(type: 2)
        }
        return AnyView(SoundButton(viewModel: viewModel))
    }
    default: do {
        if viewModel.isMute {
            watchHaptic(type: 3)
        }else {
            watchHaptic(type: 2)
        }
        return AnyView(SoundButton(viewModel: viewModel))
    }
    }
    return nil
}

//haptics
func watchHaptic(type: Int) {
    switch type {
    case 1: WKInterfaceDevice.current().play(WKHapticType.start)
    case 2: WKInterfaceDevice.current().play(WKHapticType.directionUp)
    case 3: WKInterfaceDevice.current().play(WKHapticType.navigationGenericManeuver)
    default: print("")
    }
}

//ringcolor
func ringColor(time: Int) -> (Color, [Color]) {
    switch time {
    case TimeMode.green: return (Color.green.opacity(0.2), [Color.green.opacity(0.4), Color.green])
    case TimeMode.yellow: return (Color.yellow.opacity(0.2), [Color.yellow.opacity(0.4), Color.yellow])
    case TimeMode.red: return (Color.red.opacity(0.2), [Color.red.opacity(0.4), Color.red])
    default:
        return (Color.red.opacity(0.2), [Color.red.opacity(0.4), Color.red])
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
        MainView(viewModel: MainViewModel())
    }
}
