//
//  AlarmViewModel.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import Foundation
import SwiftUI

@Observable
final class AlarmViewModel {
    var alarms: [Alarm] = []
    var activeAlarm: Alarm?
    var isChallengeActive: Bool = false
    var isSuccessPresented: Bool = false
    var showingAddSheet: Bool = false
    var editingAlarm: Alarm?
    
    private let soundManager = SoundManager.shared
    private let scheduler = AlarmScheduler.shared
    
    init() {
        self.alarms = AlarmStorage.loadAlarms()
        setupScheduler()
    }
    
    private func setupScheduler() {
        scheduler.requestNotificationPermission()
        
        scheduler.onAlarmTriggered = { [weak self] triggeredAlarm in
            self?.triggerAlarm(triggeredAlarm)
        }
        
        scheduler.startMonitoring { [weak self] in
            self?.alarms ?? []
        }
        
        scheduler.syncSystemNotifications(with: alarms)
    }
    
    func addAlarm(time: Date, label: String) {
        let cleanLabel = label.trimmingCharacters(in: .whitespaces).isEmpty ? "Wake Up" : label
        let newAlarm = Alarm(time: time, label: cleanLabel, isEnabled: true)
        alarms.append(newAlarm)
        sortAndPersist()
    }
    
    func updateAlarm(_ alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm
            sortAndPersist()
        }
    }
    
    func toggleAlarm(id: UUID) {
        if let index = alarms.firstIndex(where: { $0.id == id }) {
            alarms[index].isEnabled.toggle()
            sortAndPersist()
        }
    }
    
    func deleteAlarm(id: UUID) {
        alarms.removeAll { $0.id == id }
        sortAndPersist()
    }
    
    func deleteAlarm(at offsets: IndexSet) {
        alarms.remove(atOffsets: offsets)
        sortAndPersist()
    }
    
    /// Triggers an alarm and starts continuous looping audio.
    func triggerAlarm(_ alarm: Alarm) {
        activeAlarm = alarm
        isChallengeActive = true
        isSuccessPresented = false
        soundManager.playAlarm(soundName: alarm.soundName)
    }
    
    /// Instant test to experience the challenge and ringing right away.
    func triggerInstantTest() {
        let testAlarm = Alarm(
            time: Date(),
            label: "Test Challenge Drill",
            isEnabled: true,
            soundName: "alarm_beep"
        )
        triggerAlarm(testAlarm)
    }
    
    /// Stops the alarm audio once the typing challenge is completed.
    func completeAndDismissAlarm() {
        soundManager.stopAlarm()
        isChallengeActive = false
        isSuccessPresented = true
    }
    
    private func sortAndPersist() {
        alarms.sort { a1, a2 in
            if a1.hour != a2.hour {
                return a1.hour < a2.hour
            }
            return a1.minute < a2.minute
        }
        AlarmStorage.saveAlarms(alarms)
        scheduler.syncSystemNotifications(with: alarms)
    }
}
