//
//  WorkoutManager.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 13.01.2022.
//

import Foundation
import HealthKit
import Combine
import SwiftUI

class HealthManager: NSObject, ObservableObject {
    private let healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?

    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var flightClimbed: Double = 0

    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
    }
}

extension HealthManager {
    func initialize() {
        _initialize()
    }

    func startListening() {
        stopListening()
        createSession()
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            NSLog("Begin Collection: \(success) , error: \(error)")
        }
    }

    func stopListening() {
        session?.end()
    }
}

// MARK: - Initialize
extension HealthManager {
    private func _initialize() {
        let publisher = requestAuth()

        publisher.sink { _ in

        }.store(in: &cancellables)
    }
}

extension HealthManager: HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {

    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {

    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return
            }
            let statistics = workoutBuilder.statistics(for: quantityType)
            updateForStatistics(statistics)
        }
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {

    }

    private func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }

//        HKQuantityType(.appleStandTime),
//        HKQuantityType(.appleExerciseTime),
//        HKQuantityType(.flightsClimbed),
//        HKQuantityType(.heartRate)

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .flightsClimbed):
                let meterUnit = HKUnit.meter()
                self.flightClimbed = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }

    private func createSession() {
        let configuration = HKWorkoutConfiguration()
        configuration.locationType = .indoor
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            return
        }

        // Setup session and builder.
        session?.delegate = self
        builder?.delegate = self

        // Set the workout builder's data source.
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: configuration)
    }
}


extension HealthManager {
    private func requestAuth() -> AnyPublisher<Bool, Never> {
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]

        let typesToRead: Set = [
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.flightsClimbed),
            HKQuantityType(.heartRate)
        ]

        return Future {promise in
            self.healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { res, error in
                NSLog("Result: \(res), Error: \(error)")
                guard error == nil, res == true else {
                    promise(.success(false))
                    return
                }
                promise(.success(true))
            }
        }.eraseToAnyPublisher()

    }
}
