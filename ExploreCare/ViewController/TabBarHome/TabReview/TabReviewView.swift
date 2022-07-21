//
//  TabReviewView.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 04/07/22.
//


import SwiftUI

struct ReviewView: View {
    @AppStorage("userName") var user = "";
    @State var progressValue: Float = 0.40
    @State var openAppCount = UserDefaults.standard.integer(forKey: "totalDays")
    @State var totalObjects: Int = 6
    
    var viewModel = ObjectRecogViewModel()
    
    @AppStorage("totalRunning") var showRunning = 0;
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hallo Parents,")
                .font(.title)
                .bold()
                .padding(.leading, 20)
            Text("Welcome to "+(user)+"'s reports")
                .font(.subheadline)
                .bold()
                .padding(.leading, 20)
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.28, green: 0.71, blue: 1.00))
                    .frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 200)
                
                HStack {
                    Spacer()
                    VStack {
                        Text("I Have Learned")
                        Text(String(totalObjects)+" Objects")
                    }
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    ProgressBar(progress: self.$progressValue)
                        .frame(width: 150.0, height: 150.0)
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                    //.padding(20.0)
                    Spacer()
                }//.background(.red)
            }//.border(.brown)
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
            
            //Trio Rectangle Here
            HStack {
                VStack {
                    // Total Days
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.green)
                            .opacity(0.35)
                            .frame(maxHeight: 130)
                        VStack {
                            Text("Days")
                                .font(.title2)
                                .bold()
                            //Text(Date.now, format: .dateTime.hour().minute())
                            //Text(Date.now, format: .dateTime.day().month().year())
                            //Text(Date.now.formatted(date: .long, time: .shortened))
                            //Text(Date.now, style: .date)
                            Text(String(openAppCount))
                                .font(.largeTitle)
                                .bold()
                        }
                    }
                    // Total Time Spent
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.green)
                            .opacity(0.35)
                            .frame(maxHeight: 130)
                        VStack {
                            let (h,m,_) = secondsToHoursMinutesSeconds(showRunning)
                            //print ("\(h) Hours, \(m) Minutes, \(s) Seconds")
                            Text("Time Spent")
                                .font(.title2)
                                .bold()
                            Text(String(h)+"hr "+String(m)+"min")
                                .font(.headline)
                                .bold()
                        }.onAppear() {
                            //print(showRunning)
                        }
                    }
                }
                // Total Object
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.green)
                        .opacity(0.35)
                        .frame(maxWidth: .infinity - 20, maxHeight: 270)
                    VStack(alignment: .leading) {
                        Text("Objects found today")
                            .font(.title2)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 5)
                        Text("1. Laptop")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                        Text("2. Monitor")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                    }//.border(.red)
                }
            }//.border(.red)
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            
            ZStack {
                ZStack {
                    Text(progressValue >= 0.3 ? "Your child has a great capability in exploring! A strong interest in exploration helps your child to improve their cognitive capability" : "Just Do It")
                        .foregroundColor(.black)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 70)
                    
                    //.background(.red)
                }
                .background(Color(red: 1.00, green: 0.95, blue: 0.67))
                .cornerRadius(12)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            }
            
            //Button Here
            //NavigationLink(destination: MainView().navigationBarBackButtonHidden(true)) {
            Button("Keep exploring to improve children’s capability") {
                print("Button pressed!")
            }
            .frame(maxWidth: .infinity - 20, maxHeight: 50, alignment: .center)
            .font(.subheadline)
            .background(Color(red: 0.28, green: 0.71, blue: 1.00))
            .cornerRadius(12)
            .buttonStyle(GrowingButton())
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            //}
            
            Spacer()
        }
//        .onAppear() { //test in emulator
//            let name = UserDefaults.standard.string(forKey: loginNameDef)
//            viewModel.sendMessageToIwatch(name: name, time: 0, startExplore: true)
//        }
    }

    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.9)
                .foregroundColor(Color.white)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 25.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.red)
                .rotationEffect(Angle(degrees: 270.0))
            //.animation(.linear)
            
            VStack {
                Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                    .font(.largeTitle)
                    .bold()
                Text("Level")
                    .font(.headline)
                    .bold()
            }
        }
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ReviewView_Previews: PreviewProvider {
    @State static var selectedTab: Int = 0
    
    static var previews: some View {
        Group {
            ReviewView()
                .preferredColorScheme(.light)
            ReviewView()
                .preferredColorScheme(.dark)
            
            /*ReviewView(selectedTab: $selectedTab)
                .preferredColorScheme(.light)
            ReviewView(selectedTab: $selectedTab)
                .preferredColorScheme(.dark)*/
        }
    }
}
