//
//  MainTabView.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 12.01.2022.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: SleepLogViewModel

    var body: some View {
        TabView {
            SleepNowTabItemView()
            StatsTabItemView()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView().environmentObject(SleepLogViewModel.init())
    }
}
