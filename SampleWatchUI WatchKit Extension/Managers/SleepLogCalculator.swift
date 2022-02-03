//
//  SleepLogCalculator.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 30.01.2022.
//

import Foundation
import Combine

// Also holds values with timestamps
// Decide whether alarm should fired
// Motion rotation to angle

enum SleepLogAlarmType {
    case none
    case vibration
    case sound
}

struct SleepCalculatorResponse {
    let alarm: [SleepLogAlarmType]
    let isInterrupted: Bool
}

class SleepLogCalculator {
    private let yPosTreshold: Double = 0.25
    private let xPosTreshold: Double = 0.5

    private var interruptionStartTime: Double?

    @Published private(set) var response = SleepCalculatorResponse(alarm: [.none], isInterrupted: false)
    @Published private(set) var interruptionTimeRange: Double?

    func handle(xRotation: Double, yRotation: Double, timestamp: Double) {
        if isInterruption(xRotation: xRotation, yRotation: yRotation) {
            markInterruption(timeStamp: timestamp)
        } else {
            unMarkInterruption(timeStamp: timestamp)
        }
    }

    private func markInterruption(timeStamp: Double) {
        guard let interruptionStartTime = interruptionStartTime else {
            self.interruptionStartTime = timeStamp
            return
        }

        let diff = timeStamp - interruptionStartTime
        if diff < 15 {
            // No Alarm
            response = SleepCalculatorResponse(alarm: [.none], isInterrupted: true)
        } else if diff < 25 {
            // Vibrate
            response = SleepCalculatorResponse(alarm: [.vibration], isInterrupted: true)
        } else {
            // Vibrate + Sound
            response = SleepCalculatorResponse(alarm: [.vibration, .sound], isInterrupted: true)
        }


    }

    private func unMarkInterruption(timeStamp: Double) {
        if let interruptionStartTime = interruptionStartTime {
            let total = timeStamp - interruptionStartTime
            interruptionTimeRange = total
        }
        interruptionTimeRange = nil
        interruptionStartTime = nil
        response = SleepCalculatorResponse(alarm: [.none], isInterrupted: false)
    }


    private func isInterruption(xRotation: Double, yRotation: Double) -> Bool {
        let x = fabs(xRotation)
        let y = fabs(yRotation)
        guard x < xPosTreshold else {
            return false
        }
        return y < yPosTreshold && x < xPosTreshold
    }
}
