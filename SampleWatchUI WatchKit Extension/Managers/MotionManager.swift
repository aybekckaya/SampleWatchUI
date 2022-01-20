//
//  MotionManager.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 13.01.2022.
//

import Foundation
import CoreMotion
import Combine

class MotionManager: NSObject, ObservableObject {
    private let sampleInterval = 1.0 / 50.0
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()

    @Published var shouldShowRed: Bool = false

    override init() {
            super.init()
            queue.maxConcurrentOperationCount = 1
            queue.name = "MotionManagerQueue"
        }
}

extension MotionManager {
    func startUpdates() {
        guard motionManager.isAccelerometerAvailable else {
            return
        }
//        motionManager.deviceMotionUpdateInterval = sampleInterval
//        motionManager.accelerometerUpdateInterval = sampleInterval
        motionManager.accelerometerUpdateInterval = sampleInterval
        motionManager.startAccelerometerUpdates(to: queue) { accData, error in
            if let error = error {
                NSLog("Motion Error: \(error)")
                return
            }
            guard let accelerometerData = accData else {
                return
            }
            self.processMotion(accelerometerData)

        }

//        motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
//            if let error = error {
//                NSLog("Motion Error: \(error)")
//                return
//            }
//            guard let deviceMotion = deviceMotion else {
//                return
//            }
//            // Process Motion
//            self.processMotion(deviceMotion)
//        }
    }

    func stopUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
    }
}

// MARK: - Process
extension MotionManager {
    private func processMotion(_ accelerometerData: CMAccelerometerData) {
//        guard let rotation = motionManager.gyroData else {
//            return
//        }


        let rotationRate = accelerometerData.acceleration
        let xPos = fabs(rotationRate.x)
        let yPos = fabs(rotationRate.y)
     //   let zPos = fabs(rotationRate.z)

        let treshold: Double = 0.25

        if xPos < treshold && yPos < treshold {
            //NSLog("YES")
            shouldShowRed = true
        } else {
          //  NSLog("NO")
            shouldShowRed = false
        }

       //NSLog("Rotation: \(rotationRate)")
    }
}
