//
//  StartSleepTabItemView.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 27.01.2022.
//

import SwiftUI

private struct SleepNowButton: View {

    let edgeSize: CGFloat
    let animationDuration: Double
    @Binding var isAnimatingDismiss: Bool
    @EnvironmentObject var environment: SleepEnvironmentModel

    var body: some View {
        CircularAppButton(configuration: .init(title: "Sleep\nNow",
                                               animationDuration: animationDuration,
                                               edgeSize: edgeSize,
                                               titleColor: .whiteColor,
                                               backgroundColor: .grayColor,
                                               requiresOuterCircle: true, action: {
            self.isAnimatingDismiss = false
            self.environment.setMainViewState(.sleepLog)
            self.environment.startListening()
        }))
    }
}

private struct SleepNowMessageView: View {
    @Binding var isAnimatingDismiss: Bool
    let animationDuration: Double

    var body: some View {
        VStack {
            Text("If you sleep now it is good. If you sleep now it is good. If you sleep now it is good")
                .font(.caption)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.whiteColor)
                .opacity(isAnimatingDismiss ? 0.0 : 1.0)
                .animation(.easeInOut(duration: animationDuration), value: isAnimatingDismiss)
                .padding()
        }
    }
}

struct StartSleepTabItemView: View {
    private let animationDuration: Double = 1.0
    @State private var isAnimatingDismiss = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                SleepNowButton(edgeSize: 100, animationDuration: animationDuration, isAnimatingDismiss: $isAnimatingDismiss)
                SleepNowMessageView(isAnimatingDismiss: $isAnimatingDismiss, animationDuration: animationDuration)
            }
        }.onAppear {
            isAnimatingDismiss = false
        }
    }
}

struct StartSleepTabItemView_Previews: PreviewProvider {
    static var previews: some View {
        StartSleepTabItemView().environmentObject(SleepEnvironmentModel())
    }
}
