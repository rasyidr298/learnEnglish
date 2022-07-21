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
        ZStack {
            soundMode(viewModel: viewModel)
            VStack {
                Text("\(viewModel.name) \(textMode(viewModel: viewModel))")
                    .font(.title3)
                    .bold()
                    .multilineTextAlignment(.center)
                ZStack {
                    Rectangle()
                        .frame(width: 40, height: 15, alignment: .center)
                        .cornerRadius(5)
                        .foregroundColor(ringColor(time: viewModel.timeVal).1.last)
                    Text(timeString(time: viewModel.timeVal))
                        .font(.system(size: 7, weight: .bold, design: .serif))
                }
            }
            PercentageRing(
                ringInnerWidth: 20, ringWidth: 23, percent: Double(viewModel.timeVal) ,
                backgroundColor: ringColor(time: viewModel.timeVal).0,
                foregroundColors: ringColor(time: viewModel.timeVal).1
            )
            .frame(width: screenSize.width - 22, height: screenSize.height - 22)
            .onReceive(viewModel.objectWillChange, perform: { value in
                if viewModel.isStartExplore {
                    TimerEngine.shared.startPlayinTicks(viewModel: viewModel)
                }else {
                    TimerEngine.shared.stopPlayingTicks(type: 1)
                    TimerEngine.shared.stopPlayingTicks(type: 2)
                }
            })
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
                        if viewModel.isMute {
                            TimerEngine.shared.stopPlayingTicks(type: 1)
                        }else {
                            TimerEngine.shared.startPlayinTicks(viewModel: viewModel)
                        }
                    }
            }
        }
    }
}

//fix timer enum
enum TimeMode {
    static let stanby = 0
    static let green = 1...600
    static let yellow = 601...1200
    static let red = 1201...3000
    case outOfRange
}

//text mode
func textMode(viewModel: MainViewModel) -> String {
    switch viewModel.timeVal {
    case TimeMode.stanby: return "not \n Explore"
    case TimeMode.green: return "is \n Exploring"
    case TimeMode.yellow: return "is \n Confused"
    case TimeMode.red: return "is \n Need You"
    default: return "is \n Need You"
    }
}

//soundMode
func soundMode(viewModel: MainViewModel) -> AnyView? {
    switch viewModel.timeVal {
    case TimeMode.stanby: print("")
    case TimeMode.green: print("")
    case TimeMode.yellow: print("")
    case TimeMode.red: return AnyView(SoundButton(viewModel: viewModel))
    default:return AnyView(SoundButton(viewModel: viewModel))
    }
    return nil
}

//ringcolor
func ringColor(time: Int) -> (Color, [Color]) {
    switch time {
    case TimeMode.stanby: return (Color.green.opacity(0.2), [Color.green.opacity(0.4), Color.green.opacity(0.4)])
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
