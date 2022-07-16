//
//  learnEnglishApp.swift
//  ExploreCareW WatchKit Extension
//
//  Created by Rasyid Ridla on 14/07/22.
//

import SwiftUI

@main
struct learnEnglishApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
