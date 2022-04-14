import HealthKit

class HealthStore {
    private var myAnchor: HKQueryAnchor?
    
    private let heartRateType =
        HKQuantityType.quantityType(forIdentifier: .heartRate)!
    
    // This assumes that HKHealthStore.isHealthDataAvailable()
    // has already been checked.
    var store = HKHealthStore()

    func enableBackgroundProcessing() {
        store.enableBackgroundDelivery(
            for: heartRateType,
            frequency: .immediate
        ) { success, error in
            if let error = error {
                print("error enabling background delivery: \(error)")
            } else {
                print("enableBackgroundProcessing: success = \(success)")
                self.monitorHeartRate()
            }
        }
    }

    func hoursAgoPredicate(_ hours: Int) -> NSPredicate {
        HKQuery.predicateForSamples(
            withStart: Date().hoursAgo(hours),
            end: nil, // runs through the current time
            options: .strictStartDate
        )
    }

    func monitorHeartRate() {
        let predicate = hoursAgoPredicate(1)

        let query = HKObserverQuery(
            sampleType: heartRateType,
            predicate: nil
        ) { _, completionHandler, error in
            if let error = error {
                print(
                    "HealthStore.monitorHeartRate: error = \(error.localizedDescription)"
                )
                return
            }
            
            print("HealthStore.monitorHeartRate: observed new data")
            
            // A new query must be executed to get the data.
            let query = HKAnchoredObjectQuery(
                type: self.heartRateType,
                predicate: predicate,
                anchor: self.myAnchor,
                limit: HKObjectQueryNoLimit
            ) { _, samples, deleted, newAnchor, error in
                if let error = error {
                    print("HealthStore.monitorHeartRate: error \(error)")
                    return
                }
                
                self.myAnchor = newAnchor
                
                if let samples = samples {
                    let unit = HKUnit(from: "count/min")
                    for sample in samples {
                        let qs = sample as! HKQuantitySample
                        let heartRate = qs.quantity.doubleValue(for: unit)
                        print("heartRate = \(heartRate)")
                    }
                }
            }
            self.store.execute(query)

            // Only need to call this if we have
            // subscribed for background updates.
            completionHandler()
        }

        store.execute(query)
    }

    func requestAuthorization() async throws {
        // This throws if authorization could not be requested.
        // Not throwing is not an indication that the user
        // granted all the requested permissions.
        try await store.requestAuthorization(
            toShare: [], // app can update these
            read: [heartRateType]
        )
    }
}
