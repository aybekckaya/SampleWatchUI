//
//  SleepLogViewModel.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 12.01.2022.
//

import Foundation
import SwiftUI
import Combine

enum ViewState {
    case mainTabView
    case sleepLogView
}

class SleepLogViewModel: ObservableObject {
    @Published var currentViewState: ViewState = .mainTabView
    @Published var showRed: Bool = false
    @Published var logArr: [String] = []

    private let healthManager = HealthManager()
    private let motionManager = MotionManager()
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - Initialize
extension SleepLogViewModel {
    func initialize() {
        addListeners()
        healthManager.initialize()
    }

    func startListening() {
        healthManager.startListening()
        motionManager.startUpdates()
    }

    func stopListening() {
        healthManager.stopListening()
        motionManager.stopUpdates()
    }
}

// MARK: - Listeners
extension SleepLogViewModel {
    private func addListeners() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full

        logArr = []
        healthManager.$heartRate
            .receive(on: DispatchQueue.main, options: nil)
            .sink { val in
                let currDateStr = dateFormatter.string(from: Date.now)
                let logText = "Heart Rate at: \(currDateStr) is \(val)"
                //self.logArr.append(logText)
        }.store(in: &cancellables)

        healthManager.$flightClimbed
            .receive(on: DispatchQueue.main, options: nil)
            .sink { val in
                let currDateStr = dateFormatter.string(from: Date.now)
                let logText = "Flight climbed at: \(currDateStr) is \(val)"
              //  self.logArr.append(logText)
        }.store(in: &cancellables)


        healthManager.$activeEnergy
            .receive(on: DispatchQueue.main, options: nil)
            .sink { val in
                let currDateStr = dateFormatter.string(from: Date.now)
                let logText = "Active Energy at: \(currDateStr) is \(val)"
              //  self.logArr.append(logText)
        }.store(in: &cancellables)

        motionManager.$shouldShowRed
            .receive(on: DispatchQueue.main, options: nil)
            .sink { val in
                self.showRed = val
        }.store(in: &cancellables)

    }
}
