//
//  AlarmManager.swift
//  SampleWatchUI WatchKit Extension
//
//  Created by aybek can kaya on 31.01.2022.
//

import Foundation
import WatchKit

class AlarmManager {
    func vibrate() {
        WKInterfaceDevice.current().play(.click)
    }

    func sound() {
        WKInterfaceDevice.current().play(.notification)
    }
}

