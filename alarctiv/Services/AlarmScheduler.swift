//
//  AlarmScheduler.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import Foundation
import UserNotifications
import Combine

@MainActor
final class AlarmScheduler: NSObject, UNUserNotificationCenterDelegate {
    static let shared = AlarmScheduler()
    
    var onAlarmTriggered: ((Alarm) -> Void)?
    
    private var timer: AnyCancellable?
    private var lastTriggeredMinute: Int?
    
    override private init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("AlarmScheduler: Notification permission error: \(error.localizedDescription)")
            } else {
                print("AlarmScheduler: Notification permission granted: \(granted)")
            }
        }
    }
    
    func startMonitoring(getAlarms: @escaping () -> [Alarm]) {
        timer?.cancel()
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkAlarms(getAlarms: getAlarms)
            }
    }
    
    func stopMonitoring() {
        timer?.cancel()
        timer = nil
    }
    
    private func checkAlarms(getAlarms: () -> [Alarm]) {
        let calendar = Calendar.current
        let now = Date()
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)
        let minuteKey = currentHour * 60 + currentMinute
        
        // Prevent multiple firings in the same minute
        guard lastTriggeredMinute != minuteKey else { return }
        
        let alarms = getAlarms()
        for alarm in alarms where alarm.isEnabled {
            let alarmHour = calendar.component(.hour, from: alarm.time)
            let alarmMinute = calendar.component(.minute, from: alarm.time)
            
            if alarmHour == currentHour && alarmMinute == currentMinute {
                lastTriggeredMinute = minuteKey
                onAlarmTriggered?(alarm)
                break
            }
        }
    }
    
    func syncSystemNotifications(with alarms: [Alarm]) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let calendar = Calendar.current
        for alarm in alarms where alarm.isEnabled {
            let content = UNMutableNotificationContent()
            content.title = "⏰ Alarctiv Alarm: \(alarm.label)"
            content.body = "Wake up! Open the app now to type the challenge phrase and stop the alarm."
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "ALARM_CATEGORY"
            
            var triggerComponents = DateComponents()
            triggerComponents.hour = calendar.component(.hour, from: alarm.time)
            triggerComponents.minute = calendar.component(.minute, from: alarm.time)
            triggerComponents.second = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
            let request = UNNotificationRequest(identifier: alarm.id.uuidString, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("AlarmScheduler: Failed to schedule notification for \(alarm.label): \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Display banner/sound even if app is foregrounded
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
    
    // User interacted with notification
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let alarmId = response.notification.request.identifier
        Task { @MainActor in
            let alarms = AlarmStorage.loadAlarms()
            if let matched = alarms.first(where: { $0.id.uuidString == alarmId }) {
                self.onAlarmTriggered?(matched)
            } else if let first = alarms.first(where: { $0.isEnabled }) {
                self.onAlarmTriggered?(first)
            }
        }
        completionHandler()
    }
}
