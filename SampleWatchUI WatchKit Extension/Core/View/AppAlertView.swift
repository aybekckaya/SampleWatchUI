//
//  AppAlertView.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 30.01.2022.
//

import SwiftUI

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
                    yesClosure?()
                } label: {
                    Text(yesTitle)
                        .fontWeight(.semibold)
                        .font(.system(size: 12))

                }.clipShape(Capsule())

                Button {
                    noClosure?()
                } label: {
                    Text(noTitle)
                        .fontWeight(.semibold)
                        .font(.system(size: 12))
                }.background(Color.redColor)
                    .clipShape(Capsule())

            }
        }
    }
}
