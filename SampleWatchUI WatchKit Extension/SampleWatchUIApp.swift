//
//  SampleWatchUIApp.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 11.01.2022.
//

import SwiftUI

@main
struct SampleWatchUIApp: App {
    private static let environment = SleepEnvironmentModel()
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
                    .environmentObject(SampleWatchUIApp.environment)
                    .onAppear {
                        SampleWatchUIApp.environment.initialize()
                    }
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
