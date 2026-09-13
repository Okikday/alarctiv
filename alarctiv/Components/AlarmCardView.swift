//
//  AlarmCardView.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import SwiftUI

struct AlarmCardView: View {
    let alarm: Alarm
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(alarm.formattedTime)
                        .font(.system(size: 34, weight: .semibold, design: .rounded))
                        .foregroundStyle(alarm.isEnabled ? Color.primary : Color.secondary.opacity(0.6))
                        .monospacedDigit()
                }
                
                HStack(spacing: 8) {
                    Text(alarm.label)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(alarm.isEnabled ? .primary : .secondary)
                    
                    Text("•")
                        .foregroundStyle(.secondary.opacity(0.5))
                    
                    Text(alarm.remainingTimeDescription)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(alarm.isEnabled ? Color.blue.opacity(0.15) : Color.secondary.opacity(0.1))
                        )
                        .foregroundStyle(alarm.isEnabled ? Color.blue : Color.secondary)
                }
            }
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { alarm.isEnabled },
                set: { _ in onToggle() }
            ))
            .labelsHidden()
            .tint(.blue)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.primary.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(alarm.isEnabled ? Color.blue.opacity(0.25) : Color.primary.opacity(0.06), lineWidth: 1)
                )
        }
        .contextMenu {
            Button {
                onEdit()
            } label: {
                Label("Edit Alarm", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete Alarm", systemImage: "trash")
            }
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        AlarmCardView(
            alarm: Alarm(time: Date(), label: "Wake Up For Work", isEnabled: true),
            onToggle: {},
            onEdit: {},
            onDelete: {}
        )
        AlarmCardView(
            alarm: Alarm(time: Date(), label: "Weekend Sleep In", isEnabled: false),
            onToggle: {},
            onEdit: {},
            onDelete: {}
        )
    }
    .padding()
}
