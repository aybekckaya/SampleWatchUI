//
//  StatsTabItemView.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 12.01.2022.
//

import SwiftUI

private struct StatItemView: View {
    let title: String
    let value: String
    let valueTypeText: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.semibold)
                .font(.callout)
                .foregroundColor(.purpleColor)
                .padding([.leading], 4)

            HStack(alignment: .bottom) {
                Text(value)
                    .fontWeight(.regular)
                    .font(.title2)
                    .foregroundColor(.whiteColor.opacity(0.8))
                Text(valueTypeText)
                    .fontWeight(.regular)
                    .font(.caption)
                    .foregroundColor(.whiteColor.opacity(0.7))
                    .offset(y: -5)
            }.padding(EdgeInsets.init(top: 4, leading: 4, bottom: 0, trailing: 0))

            Rectangle()
                .foregroundColor(Color.whiteColor.opacity(0.5))
                .frame(height: 1)
        }
    }
}

struct StatsTabItemView: View {
    @EnvironmentObject var environment: SleepEnvironmentModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            StatItemView(title: "Correct Sleep", value: "\(environment.currentStatsPresentation.correctSleep.stringify())", valueTypeText: "%")
            StatItemView(title: "Uninterrupted Sleep", value: "\(environment.currentStatsPresentation.uninterruptedSleep.stringify())", valueTypeText: "min(s)")
            StatItemView(title: "Interruption (24 h)", value: "\(environment.currentStatsPresentation.numInterruptionIn24h.stringify())", valueTypeText: "time(s)")
            StatItemView(title: "Interruption (7 d)", value: "\(environment.currentStatsPresentation.numInterruptionIn7d.stringify())", valueTypeText: "time(s)")
        }
    }
}

struct StatsTabItemView_Previews: PreviewProvider {
    static var previews: some View {
        StatsTabItemView()
    }
}

extension Int {
    func stringify() -> String {
        guard self != -1 else { return "-" }
        return "\(self)"
    }
}
