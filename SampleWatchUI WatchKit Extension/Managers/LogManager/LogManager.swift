//
//  LogManager.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 31.01.2022.
//

import Foundation
import Combine


// MARK: - Manager
class LogManager {
    private let logFileURL: URL
    private(set) var currentLogModel = LogModel()

    private(set) var objectHasChanged = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    init() {
        logFileURL = URL.documentsDirectory
            .appendingPathComponent("AppData")
            .appendingPathExtension("json")
        logFileURL.createFileIfNotExists()
        initialize()
    }
}

// MARK: - Initialize
extension LogManager {

    private func initialize() {
       let publisher = logFileURL.readContentsRx()
            .flatMap { data -> AnyPublisher<LogModel, Never> in
                guard let data = data,
                      let model = try? JSONDecoder().decode(LogModel.self, from: data)
                else {
                    return Just(LogModel()).eraseToAnyPublisher()
                }
                return Just(model).eraseToAnyPublisher()
            }.flatMap { model -> AnyPublisher<Bool, Never> in
                self.currentLogModel = model
                return Just(true).eraseToAnyPublisher()
            }

        publisher.sink { [weak self] _ in
            guard let self = self else { return }
            self.objectHasChanged.send()
        }.store(in: &cancellables)

    }
}

// MARK: - Public
extension LogManager {
    func save() {
        guard let data = try? JSONEncoder().encode(currentLogModel) else {
            return
        }
        logFileURL.writeDataRx(data).sink { [weak self] _ in
            guard let self = self else { return }
            self.objectHasChanged.send()
        }.store(in: &cancellables)
    }

    func startSleep() {
        if let _ = getActiveLogModel() {
            stopSleep()
        }
        let currentLogMD = currentLogModel
        let newModel = SleepLogModel()
        newModel.isActive = true
        newModel.sleepStartTime = Date().timeIntervalSince1970
        newModel.secondsInterrupted = 0
        currentLogMD.logs.append(newModel)
        currentLogModel = currentLogMD
        self.objectHasChanged.send()
        NSLog("Started Sleep")
    }

    func stopSleep() {
        guard let activeModel = getActiveLogModel() else {
            return
        }
        activeModel.isActive = false
        activeModel.sleepEndTime = Date().timeIntervalSince1970
        self.objectHasChanged.send()
        NSLog("Stopped Sleep")
    }

    func addInterruption(seconds: Double) {
        guard let activeModel = getActiveLogModel() else {
            return
        }
        activeModel.secondsInterrupted += seconds
        activeModel.timesInterrupted += 1
        self.objectHasChanged.send()
    }
}

// MARK: - Active Log Model
extension LogManager {
    private func getActiveLogModel() -> SleepLogModel? {
        return self.currentLogModel.logs.first { $0.isActive == true }
    }
}
