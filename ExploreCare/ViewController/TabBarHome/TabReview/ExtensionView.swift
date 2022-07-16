//
//  ExtensionView.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 14/07/22.
//

import SwiftUI

//screen size
//extension UIScreen {
//#if os(watchOS)
//    static let screenSize = WKInterfaceDevice.current().screenBounds.size
//    static let screenWidth = screenSize.width
//    static let screenHeight = screenSize.height
//#elseif os(iOS) || os(tvOS)
//    static let screenSize = UIScreen.main.nativeBounds.size
//    static let screenWidth = screenSize.width
//    static let screenHeight = screenSize.height
//#elseif os(macOS)
//    static let screenSize = NSScreen.main?.visibleFrame.size
//    static let screenWidth = screenSize.width
//    static let screenHeight = screenSize.height
//#endif
//    static let middleOfScreen = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
//}

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

struct RingBackgroundShape: Shape {
    
    var thickness: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.width / 2, y: rect.height / 2),
            radius: rect.width / 2 - thickness,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 360),
            clockwise: false
        )
        return path
            .strokedPath(.init(lineWidth: thickness, lineCap: .round, lineJoin: .round))
    }
    
}

struct RingShape: Shape {
    
    var currentPercentage: Double
    var thickness: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.addArc(
            center: CGPoint(x: rect.width / 2, y: rect.height / 2),
            radius: rect.width / 2 - thickness,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 360 * currentPercentage),
            clockwise: false
        )
        
        return path
            .strokedPath(.init(lineWidth: thickness, lineCap: .round, lineJoin: .round))
    }
    
    var animatableData: Double {
        get { return currentPercentage }
        set { currentPercentage = newValue }
    }
}

struct RingTipShape: Shape {
    
    var currentPercentage: Double
    var thickness: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let angle = CGFloat((360 * currentPercentage) * .pi / 180)
        let controlRadius: CGFloat = rect.width / 2 - thickness
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let x = center.x + controlRadius * cos(angle)
        let y = center.y + controlRadius * sin(angle)
        let pointCenter = CGPoint(x: x, y: y)
        
        path.addEllipse(in:
            CGRect(
                x: pointCenter.x - thickness / 2,
                y: pointCenter.y - thickness / 2,
                width: thickness,
                height: thickness
            )
        )
        
        return path
    }
    
    var animatableData: Double {
        get { return currentPercentage }
        set { currentPercentage = newValue }
    }
    
}

struct RingView: View {
    
    @State var currentPercentage: Double = 0
    
    var percentage: Double
    var backgroundColor: Color
    var startColor: Color
    var endColor: Color
    var thickness: CGFloat

    var animation: Animation {
        Animation.easeInOut(duration: 1)
    }
    
    var body: some View {
        let gradient = AngularGradient(gradient: Gradient(colors: [startColor, endColor]), center: .center, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360 * currentPercentage))
        return ZStack {
            RingBackgroundShape(thickness: thickness)
                .fill(backgroundColor)
            RingShape(currentPercentage: currentPercentage, thickness: thickness)
                .fill(gradient)
                .rotationEffect(.init(degrees: -90))
                .shadow(radius: 2)
                .drawingGroup()
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(self.animation) {
                            self.currentPercentage = self.percentage
                        }
                    }
                }
            RingTipShape(currentPercentage: currentPercentage, thickness: thickness)
                .fill(currentPercentage > 1 ? endColor : .clear)
                .rotationEffect(.init(degrees: -90))
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(self.animation) {
                            self.currentPercentage = self.percentage
                        }
                    }
                }
        }
    }
    
}


//backgroundColor: Color(red: 237.0 / 255.0, green: 237.0 / 255.0, blue: 242.0 / 255.0),
//startColor: Color(red: 210 / 255, green: 19 / 255, blue: 49 / 255),
//endColor: Color(red: 255 / 255, green: 50 / 255, blue: 135 / 255),


//backgroundColor: Color(red: 237.0 / 255.0, green: 237.0 / 255.0, blue: 242.0 / 255.0),
//startColor: Color(red: 63 / 255, green: 212 / 255, blue: 0 / 255),
//endColor: Color(red: 184 / 255, green: 255 / 255, blue: 0 / 255),

struct Extension_Previews: PreviewProvider {
    static var previews: some View {
        RingView(
            percentage: 0.6,
            backgroundColor: Color(red: 237.0 / 255.0, green: 237.0 / 255.0, blue: 242.0 / 255.0),
            startColor: Color(red: 63 / 255, green: 212 / 255, blue: 0 / 255),
            endColor: Color(red: 184 / 255, green: 255 / 255, blue: 0 / 255),
            thickness: 29
        )
        .frame(width: 300, height: 300)
        .aspectRatio(contentMode: .fit)
    }
}
