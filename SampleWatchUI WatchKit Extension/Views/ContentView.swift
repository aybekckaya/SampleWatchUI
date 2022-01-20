//
//  ContentView.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 11.01.2022.
//

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var viewModel: SleepLogViewModel

    var body: some View {
        ZStack {
            Color.blackColor
                .ignoresSafeArea()
                switch viewModel.currentViewState {
                case .mainTabView:
                    MainTabView()
                case .sleepLogView:
                    SleepLogView()
                }

        }.onAppear {
            viewModel.initialize()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(SleepLogViewModel.init())
        }
    }
}
