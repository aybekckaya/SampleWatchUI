//
//  MotionManager.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 13.01.2022.
//

import Foundation
import CoreMotion
import Combine
import UIKit

enum MotionManagerError: Error {
    case builtInError(Error)
    case accelerometerUnavailable
    case accelerometerDataNotReceived
}

struct MotionManagerResponse {
    let error: MotionManagerError?
    let xPosition: Double?
    let yPosition: Double?
    let timestamp: Double?

    init(error: MotionManagerError) {
        self.error = error
        self.xPosition = nil
        self.yPosition = nil
        self.timestamp = nil
    }

    init(xPos: Double, yPos: Double, timestamp: Double) {
        self.error = nil
        self.yPosition = yPos
        self.xPosition = xPos
        self.timestamp = timestamp
    }

    init() {
        self.error = nil
        self.xPosition = nil
        self.yPosition = nil
        self.timestamp = nil
    }
}

class MotionManager: NSObject, ObservableObject {
    private let sampleInterval: Double
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()

    @Published private(set) var currentResponse = MotionManagerResponse()

    init(sampleInterval: Double) {
        self.sampleInterval = sampleInterval
        super.init()
        queue.maxConcurrentOperationCount = 1
        queue.name = "MotionManagerQueue"
    }
}

// MARK: - Public
extension MotionManager {
    func startUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            currentResponse = MotionManagerResponse(error: .accelerometerUnavailable)
            return
        }
        motionManager.deviceMotionUpdateInterval = sampleInterval
        motionManager.startDeviceMotionUpdates(to: queue) { [weak self] motion, error in
            guard let self = self else {
                return
            }
            self.handleDeviceMotionResponse(motion: motion, error: error)
        }
    }

    func stopUpdates() {
        guard motionManager.isDeviceMotionAvailable,
                motionManager.isDeviceMotionActive else {
            return
        }
        motionManager.stopDeviceMotionUpdates()
    }
}

// MARK: - Process
extension MotionManager {
    private func handleDeviceMotionResponse(motion: CMDeviceMotion?, error: Error?) {
        if let error = error {
            currentResponse = .init(error: .builtInError(error))
            stopUpdates()
            return
        }

        guard let motion = motion else {
            return
        }

        let attitude = motion.attitude
        let y = CGFloat(-attitude.pitch * 2 / .pi)
        let x = CGFloat(-attitude.roll * 2 / .pi)
        let timestamp = Date().timeIntervalSince1970
        currentResponse = .init(xPos: x, yPos: y, timestamp: timestamp)
    }
}


