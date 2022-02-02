//
//  SleepLogView.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 12.01.2022.
//

import SwiftUI

private struct SleepLogStopAlertView: View {
    @Binding var showsAlertView: Bool

    var body: some View {
        AppAlertView(title: "Alert", descriptionText: "Do you want to stop sleeping ? ", yesTitle: "Continue", noTitle: "Stop", yesClosure: {
            showsAlertView = false

        }, noClosure: {

            // Change Screen by view Model
        })
    }
}

private struct SleepLogStopButton: View {
    @Binding var showsAlertView: Bool
    var body: some View {
        Button {
            showsAlertView = true
        } label: {
            Text("Wake Up")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color.whiteColor)
                .padding()
                .frame(width: 100, height: 100)
        }.background(Color.redColor)
            .clipShape(Circle())
            .shadow(color: Color.blackColor, radius: 48)
    }
}


// MARK: - Main View
struct SleepLogView: View {
    @EnvironmentObject var environment: SleepEnvironmentModel
    @State var showsAlertView: Bool = false

    var body: some View {
        ZStack {
            //viewModel.showRed ? Color.red.ignoresSafeArea() : Color.green.ignoresSafeArea()
            VStack {
                if showsAlertView {
                    SleepLogStopAlertView(showsAlertView: $showsAlertView)
                } else {
                    SleepLogStopButton(showsAlertView: $showsAlertView)
                }
            }
        }

        .onDisappear {
            environment.stopListening()
        }
        
        .onAppear {
            environment.startListening()
        }
    }
}

struct SleepLogView_Previews: PreviewProvider {
    static var previews: some View {
        SleepLogView().environmentObject(SleepEnvironmentModel.init())
        AppAlertView(title: "Alert", descriptionText: "Do you want to stop sleeping?", yesTitle: "Yes", noTitle: "No", yesClosure: {

        }, noClosure: {

        })
    }
}
