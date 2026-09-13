//
//  AlarmStorage.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import Foundation

enum AlarmStorage {
    private static let key = "alarctiv_saved_alarms"
    
    static func loadAlarms() -> [Alarm] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return defaultAlarms()
        }
        
        do {
            let alarms = try JSONDecoder().decode([Alarm].self, from: data)
            return alarms.isEmpty ? defaultAlarms() : alarms
        } catch {
            print("AlarmStorage: Failed to decode alarms: \(error.localizedDescription)")
            return defaultAlarms()
        }
    }
    
    static func saveAlarms(_ alarms: [Alarm]) {
        do {
            let data = try JSONEncoder().encode(alarms)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("AlarmStorage: Failed to encode alarms: \(error.localizedDescription)")
        }
    }
    
    private static func defaultAlarms() -> [Alarm] {
        let calendar = Calendar.current
        var comps = calendar.dateComponents([.year, .month, .day], from: Date())
        comps.hour = 7
        comps.minute = 0
        comps.second = 0
        let morningDate = calendar.date(from: comps) ?? Date()
        
        return [
            Alarm(time: morningDate, label: "Morning Awakening", isEnabled: true)
        ]
    }
}
