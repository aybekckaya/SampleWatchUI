//
//  LogModel.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 1.02.2022.
//

import Foundation
import Combine

class SleepLogModel: Codable {
    var isActive: Bool = false
    var sleepStartTime: Double?
    var sleepEndTime: Double?
    var secondsInterrupted: Double = 0
    var timesInterrupted: Int = 0

    init() {}

    static func random() -> SleepLogModel {
        let model = SleepLogModel()
        model.sleepStartTime = (Date() - Int.random(in: 0 ..< (24 * 7 * 60)).minutes).timeIntervalSince1970
        model.sleepEndTime = model.sleepStartTime! + Double(Int.random(in: 0 ..< (24 * 7 * 59 * 59)))
        model.isActive = false
        model.secondsInterrupted = Double(Int.random(in: 0 ..< Int(model.sleepEndTime! - model.sleepStartTime!)))
        model.timesInterrupted = Int.random(in: 0 ..< 10)
        return model 
    }
}

class LogModel: Codable {
    var logs: [SleepLogModel] = []

    init() {}

    func correctSleepPercentage() -> Int {
        guard logs.count > 0 else {
            return 0
        }
        var interruptionTime: Double = 0
        var totalTime: Double = 0
        logs.forEach {
            guard let start = $0.sleepStartTime,
                    let end = $0.sleepEndTime else {
                return
            }

            interruptionTime += $0.secondsInterrupted
            totalTime += (end - start)
        }

        return Int(interruptionTime * 100 / totalTime)
    }

    func uninterruptedSleep() -> Int {
        guard logs.count > 0 else {
            return 0
        }
        var interruptionTime: Double = 0
        var totalTime: Double = 0
        logs.forEach {
            guard let start = $0.sleepStartTime,
                    let end = $0.sleepEndTime else {
                return
            }
            interruptionTime += $0.secondsInterrupted
            totalTime += (end - start)
        }
        return Int(totalTime - interruptionTime) / 60
    }

    func interruptionTimes(in hours: Int) -> Int {
        guard logs.count > 0 else {
            return 0
        }
        let minTime = Int(Date().timeIntervalSince1970) - hours * 60 * 60
        var times: Int = 0
        logs.forEach {
            guard let start = $0.sleepStartTime,
                    let _ = $0.sleepEndTime,
                    Int(start) > minTime
            else {
                return
            }
            times += $0.timesInterrupted
        }
        return times
    }

}
