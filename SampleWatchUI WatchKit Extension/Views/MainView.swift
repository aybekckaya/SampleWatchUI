//
//  MainTabView.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 12.01.2022.
//

import SwiftUI

private struct AppTabView: View {
    var body: some View {
        TabView {
            StartSleepTabItemView()
            StatsTabItemView()
        }
    }
}

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var environment: SleepEnvironmentModel

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                switch environment.currentMainViewState {
                case .tabView:
                    AppTabView()
                case .sleepLog:
                    SleepLogView()
                }
            }
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("State: Active Initialize Log Model ")

            } else if newPhase == .inactive {
               // print("State: Inactive")
            } else if newPhase == .background {
                print("State: Background Save Log Model ")
                environment.logManager.save()
            }
        }.onAppear {
          
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(SleepEnvironmentModel.init())
    }
}
