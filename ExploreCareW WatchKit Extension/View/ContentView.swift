//
//  ContentView.swift
//  ExploreCareW WatchKit Extension
//
//  Created by Rasyid Ridla on 14/07/22.
//

import SwiftUI

struct ContentView: View {
    @State var progressValue: Float = 100
    let screenSize = WKInterfaceDevice.current().screenBounds.size
    
    var body: some View {
        ProgressBar(progress: self.$progressValue)
            .frame(width: screenSize.width - 50, height: screenSize.height - 100)
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
