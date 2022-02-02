//
//  CircularAppButton.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 13.01.2022.
//

import SwiftUI

struct CircularAppButtonConfiguration {
    let title: String
    let animationDuration: Double
    let edgeSize: CGFloat
    let titleColor: Color
    let backgroundColor: Color
    let requiresOuterCircle: Bool
    let action: (() -> Void)?
}

// MARK: - Outer Circle
private struct OuterCircle: View {
    let edgeSize: CGFloat
    let animationDuration: Double
    @Binding var isAnimatingTap: Bool

    var body: some View {
        Circle()
            .stroke(Color.grayColor, lineWidth: 2)
            .opacity(isAnimatingTap ? 0.0 : 1.0)
            .scaleEffect(isAnimatingTap ? 1.5 : 1.0)
            .frame(width: edgeSize, height: edgeSize)
            .animation(.easeInOut(duration: 1.0), value: isAnimatingTap)
    }
}

// MARK: - Circle Button
private struct CircleButton: View {
    let configuration: CircularAppButtonConfiguration
    @Binding var isAnimatingTap: Bool

    var body: some View {
        Button {
            isAnimatingTap = true
            if let action = self.configuration.action {
                action()
            }
        } label: {
            Text(configuration.title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color.whiteColor)
                .padding()
                .frame(width: configuration.edgeSize, height: configuration.edgeSize)
        }.background(configuration.backgroundColor)
            .clipShape(Circle())
            .shadow(color: Color.blackColor, radius: 48)
            .opacity(isAnimatingTap ? 0.0 : 1.0)
            .animation(.easeInOut(duration: 1.0), value: isAnimatingTap)

    }

}


// MARK: - Circular Button
struct CircularAppButton: View {
    let configuration: CircularAppButtonConfiguration

    @State private var isAnimatingTap: Bool = false
    
    var body: some View {
        ZStack {
            if configuration.requiresOuterCircle {
                OuterCircle(edgeSize: configuration.edgeSize * 1.3,
                            animationDuration: 1.5,
                            isAnimatingTap: $isAnimatingTap)
            }
            CircleButton(configuration: configuration,
                         isAnimatingTap: $isAnimatingTap)
                .onAppear {
                self.isAnimatingTap = false
            }
        }
    }
}

struct CircularAppButton_Previews: PreviewProvider {
    static let configuration = CircularAppButtonConfiguration(title: "Sleep\nNow", animationDuration: 1.0, edgeSize: 100, titleColor: Color.whiteColor, backgroundColor: Color.purpleColor, requiresOuterCircle: true, action: nil)
    static var previews: some View {
        CircularAppButton(configuration: configuration)
    }
}
