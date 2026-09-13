//
//  Alarm.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import Foundation

struct Alarm: Identifiable, Codable, Equatable, Hashable {
    var id: UUID = UUID()
    var time: Date
    var label: String
    var isEnabled: Bool
    var soundName: String = "alarm_beep"
    
    init(id: UUID = UUID(), time: Date, label: String = "Wake Up", isEnabled: Bool = true, soundName: String = "alarm_beep") {
        self.id = id
        self.time = time
        self.label = label
        self.isEnabled = isEnabled
        self.soundName = soundName
    }
    
    var hour: Int {
        Calendar.current.component(.hour, from: time)
    }
    
    var minute: Int {
        Calendar.current.component(.minute, from: time)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
    
    var remainingTimeDescription: String {
        guard isEnabled else { return "Disabled" }
        
        let calendar = Calendar.current
        let now = Date()
        
        var targetComponents = calendar.dateComponents([.hour, .minute], from: time)
        let nowComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)
        
        targetComponents.year = nowComponents.year
        targetComponents.month = nowComponents.month
        targetComponents.day = nowComponents.day
        targetComponents.second = 0
        
        guard var targetDate = calendar.date(from: targetComponents) else {
            return "Alarm set"
        }
        
        if targetDate <= now {
            // Target is tomorrow
            targetDate = calendar.date(byAdding: .day, value: 1, to: targetDate) ?? targetDate
        }
        
        let diff = calendar.dateComponents([.hour, .minute], from: now, to: targetDate)
        let hours = diff.hour ?? 0
        let minutes = diff.minute ?? 0
        
        if hours == 0 && minutes == 0 {
            return "Rings in less than a minute"
        } else if hours == 0 {
            return "Rings in \(minutes)m"
        } else {
            return "Rings in \(hours)h \(minutes)m"
        }
    }
}
