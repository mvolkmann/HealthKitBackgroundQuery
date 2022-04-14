import Foundation

import BackgroundTasks
import HealthKit
import SwiftUI
import UIKit

// This is registered in HealthKitBackgroundQueryApp.swift.
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [
            UIApplication.LaunchOptionsKey: Any
        ]? = nil
    ) -> Bool {
        Task {
            await bgSetup()
        }
        return true
    }

    private func bgSetup() async {
        if HKHealthStore.isHealthDataAvailable() {
            do {
                let store = HealthStore()

                // The user will only be prompted if they
                // have not already granted or denied permission.
                try await store.requestAuthorization()
                
                // Must do this AFTER requesting authorization
                // to access HealthKit data.
                store.enableBackgroundProcessing()
            } catch {
                print("AppDelegate bgSetup: health data auth failed")
            }
        } else {
            print("AppDelegate bgSetup: health data not available")
        }
    }
}
