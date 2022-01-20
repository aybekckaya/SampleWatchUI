//
//  SleepLogView.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 12.01.2022.
//

import SwiftUI

// cancel ve submit durumları
struct AppAlertView: View {
    let title: String
    let descriptionText: String
    let yesTitle: String
    let noTitle: String

    let yesClosure: (() -> Void)?
    let noClosure: (() -> Void)?

    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .fontWeight(.bold)
                .font(.system(size: 16))
            Text(descriptionText)
                .fontWeight(.regular)
                .font(.system(size: 12))
                .padding(.vertical)

            HStack(alignment: .center) {
                Button {

                } label: {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .font(.system(size: 12))

                }.clipShape(Capsule())

                Button {

                } label: {
                    Text("Stop")
                        .fontWeight(.semibold)
                        .font(.system(size: 12))
                }.background(Color.redColor)
                    .clipShape(Capsule())

            }
        }
    }
}


private struct SleepLogStopAlertView: View {
    @EnvironmentObject var viewModel: SleepLogViewModel
    @Binding var showsAlertView: Bool
    @Binding var isAnimatingTap: Bool

    var body: some View {
        AppAlertView(title: "Alert", descriptionText: "Do you want to stop sleeping ? ", yesTitle: "Continue", noTitle: "Stop", yesClosure: {

        }, noClosure: {

        })
    }
}

private struct SleepLogStopButton: View {
    @Binding var showsAlertView: Bool
    @Binding var isAnimatingTap: Bool

    var body: some View {
        CircularAppButton(configuration: .init(title: "Wake Up",
                                               animationDuration: 1.0,
                                               edgeSize: 100,
                                               titleColor: .whiteColor,
                                               backgroundColor: .redColor,
                                               requiresOuterCircle: false,
                                               action: {
                                                    self.showsAlertView = true
                                                }))
    }
}

private struct SleepLogListView: View {
    @EnvironmentObject var viewModel: SleepLogViewModel
    @Binding var isAnimatingTap: Bool

    var body: some View {
        VStack {
            Text("X: ")
                .fontWeight(.semibold)
                .font(.system(size: 18))

            Text("Y: ")
                .fontWeight(.semibold)
                .font(.system(size: 18))

            Text("Z: ")
                .fontWeight(.semibold)
                .font(.system(size: 18))
        }.opacity(isAnimatingTap ? 0 : 1)
            .animation(.easeInOut(duration: 0.5), value: isAnimatingTap)
            .padding(.vertical)
    }
}

private struct SleepLogScrollView: View {
    @EnvironmentObject var viewModel: SleepLogViewModel
    @Binding var showsAlertView: Bool
    @Binding var isAnimatingTap: Bool

    var body: some View {
        TabView {
            //SleepLogListView(isAnimatingTap: $isAnimatingTap)
            SleepLogStopButton(showsAlertView: $showsAlertView, isAnimatingTap: $isAnimatingTap)
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack {
                    //SleepLogStopButton(showsAlertView: $showsAlertView, isAnimatingTap: $isAnimatingTap)
                    ForEach(viewModel.logArr, id: \.self) { element in
                        Text(element).foregroundColor(.white)
                    }
                }
            }
        }
       
    }
}

// MARK: - Main View
struct SleepLogView: View {
    @EnvironmentObject var viewModel: SleepLogViewModel
    @State var showsAlertView: Bool = false
    @State var isAnimatingTap: Bool = false

    var body: some View {
        ZStack {
            viewModel.showRed ? Color.red.ignoresSafeArea() : Color.green.ignoresSafeArea()
            VStack {
                if showsAlertView {
                    SleepLogStopAlertView(showsAlertView: $showsAlertView, isAnimatingTap: $isAnimatingTap)
                } else {
                    SleepLogScrollView(showsAlertView: $showsAlertView, isAnimatingTap: $isAnimatingTap)
                }
            }
        }

    }
}

struct SleepLogView_Previews: PreviewProvider {
    static var previews: some View {
        SleepLogView().environmentObject(SleepLogViewModel.init())
        AppAlertView(title: "Alert", descriptionText: "Do you want to stop sleeping?", yesTitle: "Yes", noTitle: "No", yesClosure: {

        }, noClosure: {

        })
    }
}
