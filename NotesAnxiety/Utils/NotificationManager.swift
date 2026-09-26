//
//  NotificationManager.swift
//  NotesAnxiety
//
//  Created by Nadhif Rahman Alfan on 16/07/24.
//

import Foundation
import UserNotifications
import CoreLocation
import HealthKit

@MainActor
final class NotificationManager {
    private let healthStore = HKHealthStore()
    private var heartRate: Double = 0.0
    static let shared = NotificationManager()
    private var timer: Timer?
    private var observerQuery: HKObserverQuery?
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("Error: - \(error.localizedDescription)")
            } else {
            }
        }
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        healthStore.requestAuthorization(toShare: nil, read: [heartRateType]) { (success, error) in
            if !success {
                print("HealthKit authorization failed: \(String(describing: error))")
            } else {
                Task { @MainActor in
                    NotificationManager.shared.startHeartRateObserverQuery()
                }
            }
        }
    }
    
    func startHeartRateObserverQuery() {
        if let existingQuery = observerQuery {
            healthStore.stop(existingQuery)
        }
        
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        observerQuery = HKObserverQuery(sampleType: heartRateType, predicate: nil) { (query, completionHandler, error) in
            Task { @MainActor in
                NotificationManager.shared.fetchLatestHeartRate()
            }
            completionHandler()
        }
        
        healthStore.execute(observerQuery!)
        self.fetchLatestHeartRate()
    }
    
    private func fetchLatestHeartRate() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            guard let sample = samples?.first as? HKQuantitySample else { return }
            let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            Task { @MainActor in
                let manager = NotificationManager.shared
                manager.heartRate = heartRate
                manager.checkHeartRateThreshold()
            }
        }
        healthStore.execute(query)
    }
    
    private func checkHeartRateThreshold() {
        let baselineHeartRate = self.heartRate // Your baseline heart rate value, replace with actual baseline if available
        let increaseThreshold = baselineHeartRate * 1.20 // 20% increase threshold
        if heartRate >= increaseThreshold {
            sendNotification()
        }

        // Schedule the next call to startHeartRateObserverQuery after 10 seconds
        Task {
            try? await Task.sleep(for: .seconds(60))
            startHeartRateObserverQuery()
        }
    }
    
    public func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "You seem anxious, are you okay?"
        content.body = "How about writing it down and try to take a deep breath?"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false))
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Failed to send notification: \(error)")
            }
        }
    }
    
    func scheduleNotification(trigger: TriggerType) {
        let content = UNMutableNotificationContent()
        content.title = "Feeling anxious today?"
        content.body = "Try writing down what you're feeling to make you feel better"
        content.sound = .default
        content.badge = 1
        
        // Older builds added a new reminder with a random ID on every launch;
        // clear those, then use a fixed ID so re-scheduling replaces it.
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        let request = UNNotificationRequest(identifier: "reminder.\(trigger.rawValue)", content: content, trigger: trigger.trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func clearNotification() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
}

enum TriggerType: String {
    case time = "time"
    case calendar = "calendar"
    case location = "location"
    
    var trigger: UNNotificationTrigger {
        switch self {
        case .time:
            return UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        case .calendar:
            let dateComponent = DateComponents(hour: 10, minute: 45)
            return UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        case .location:
            let coordinate = CLLocationCoordinate2D(latitude: 40.0, longitude: 50.0)
            let region = CLCircularRegion(center: coordinate, radius: 100, identifier: UUID().uuidString)
            return UNLocationNotificationTrigger(region: region, repeats: true)
        }
    }
}
