//
//  SampleWatchUIApp.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 11.01.2022.
//

import SwiftUI

@main
struct SampleWatchUIApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(SleepLogViewModel.init())
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
