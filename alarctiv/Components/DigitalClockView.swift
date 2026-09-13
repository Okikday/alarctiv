//
//  DigitalClockView.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import SwiftUI
import Combine

struct DigitalClockView: View {
    @State private var currentTime: Date = Date()
    private let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter.string(from: currentTime)
    }
    
    private var secondsString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = ":ss"
        return formatter.string(from: currentTime)
    }
    
    private var amPmString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        return formatter.string(from: currentTime)
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: currentTime)
    }
    
    var body: some View {
        VStack(spacing: 6) {
            Text(dateString.uppercased())
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .tracking(1.5)
                .foregroundStyle(.secondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(timeString)
                    .font(.system(size: 54, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.primary)
                
                Text(secondsString)
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                
                Text(amPmString)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(.blue)
                    .padding(.leading, 4)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.primary.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                )
        }
        .onReceive(timer) { newTime in
            currentTime = newTime
        }
    }
}

#Preview {
    DigitalClockView()
        .padding()
}
