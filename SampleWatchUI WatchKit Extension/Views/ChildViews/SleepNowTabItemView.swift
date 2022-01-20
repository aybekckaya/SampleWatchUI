//
//  SleepButtonView.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 12.01.2022.
//

import SwiftUI

private struct SleepNowButton: View {
    let edgeSize: CGFloat
    let animationDuration: Double
    @Binding var isAnimatingTap: Bool
    @EnvironmentObject var viewModel: SleepLogViewModel

    var body: some View {
        CircularAppButton(configuration: .init(title: "Sleep\nNow",
                                               animationDuration: animationDuration,
                                               edgeSize: edgeSize,
                                               titleColor: .whiteColor,
                                               backgroundColor: .grayColor,
                                               requiresOuterCircle: true, action: {
            self.viewModel.currentViewState = .sleepLogView
            self.viewModel.startListening()
        }))
    }
}

private struct SleepNowMessageView: View {
    @Binding var isAnimating: Bool
    let animationDuration: Double
    var body: some View {
        VStack {
            Text("If you sleep now it is good. If you sleep now it is good. If you sleep now it is good")
                .font(.caption)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.whiteColor)
                .opacity(isAnimating ? 0.0 : 1.0)
                .animation(.easeInOut(duration: animationDuration), value: isAnimating)
                .padding()
        }
    }
}

struct SleepNowTabItemView: View {
    private let animationDuration: Double = 1.0
    @EnvironmentObject var viewModel: SleepLogViewModel
    @State private var isAnimating = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                SleepNowButton(edgeSize: 100, animationDuration: animationDuration, isAnimatingTap: $isAnimating)
                SleepNowMessageView(isAnimating: $isAnimating, animationDuration: animationDuration)
            }
        }
    }
}


struct SleepButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SleepNowTabItemView().environmentObject(SleepLogViewModel.init())
    }
}
