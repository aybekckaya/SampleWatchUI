//
//  SleepLogViewModel.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 12.01.2022.
//

import Foundation
import SwiftUI
import Combine

enum MainViewState {
    case tabView
    case sleepLog
}

struct StatsPresentation {
    let correctSleep: Int
    let uninterruptedSleep: Int
    let numInterruptionIn24h: Int
    let numInterruptionIn7d: Int
}

class SleepEnvironmentModel: ObservableObject {

    @Published private(set) var currentMainViewState: MainViewState = .tabView
    @Published private(set) var currentStatsPresentation = StatsPresentation(correctSleep: -1,
                                                                             uninterruptedSleep: -1,
                                                                             numInterruptionIn24h: -1,
                                                                             numInterruptionIn7d: -1)

    let logManager = LogManager()
    private let alarmManager = AlarmManager()
    private let healthManager = HealthManager()
    private let calculator = SleepLogCalculator()
    private let motionManager = MotionManager(sampleInterval: 1.0) // Every 1 seconds
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - Initialize
extension SleepEnvironmentModel {
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

    func setMainViewState(_ state: MainViewState) {
        guard currentMainViewState != state else {
            return
        }
        currentMainViewState = state
    }
}

// MARK: - Listeners
extension SleepEnvironmentModel {
    private func addListeners() {
        // 0.25 treshold
        motionManager.$currentResponse
            .receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] res in
                guard let self = self else { return }
                self.handleMotionResponse(res)
            }.store(in: &cancellables)

        calculator.$response
            .receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] response in
                guard let self = self else { return }
                self.handleCalculatorResponse(response)
            }.store(in: &cancellables)

        logManager.objectHasChanged
            .receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self]  _ in
                guard let self = self else { return }
                self.updateStats()
        }.store(in: &cancellables)
    }
}

// MARK: - Stat
extension SleepEnvironmentModel {
    private func updateStats() {
        let presentation = StatsPresentation(correctSleep: logManager.currentLogModel.correctSleepPercentage(),
                                             uninterruptedSleep: logManager.currentLogModel.uninterruptedSleep(),
                                             numInterruptionIn24h: logManager.currentLogModel.interruptionTimes(in: 24),
                                             numInterruptionIn7d: logManager.currentLogModel.interruptionTimes(in: 7 * 24))
        self.currentStatsPresentation = presentation
    }
}

// MARK: - Motion Response
extension SleepEnvironmentModel {
    private func handleMotionResponse(_ response: MotionManagerResponse) {
        if let error = response.error {
            NSLog("Error: \(error)")
            return
        }

        guard let xPos = response.xPosition, let yPos = response.yPosition, let time = response.timestamp else {
            return
        }

        calculator.handle(xRotation: xPos, yRotation: yPos, timestamp: time)
    }
}

// MARK: - Calculator Response
extension SleepEnvironmentModel {
    private func handleCalculatorResponse(_ response: SleepCalculatorResponse) {
        if response.alarm.contains(.sound) && response.alarm.contains(.vibration) {
            alarmManager.sound()
        } else if response.alarm.contains(.vibration) {
            alarmManager.vibrate()
        }

    }
}

