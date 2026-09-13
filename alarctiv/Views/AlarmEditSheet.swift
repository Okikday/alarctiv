//
//  AlarmEditSheet.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import SwiftUI

struct AlarmEditSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedTime: Date
    @State private var label: String
    
    let existingAlarm: Alarm?
    let onSave: (Date, String) -> Void
    
    init(alarm: Alarm? = nil, onSave: @escaping (Date, String) -> Void) {
        self.existingAlarm = alarm
        self.onSave = onSave
        _selectedTime = State(initialValue: alarm?.time ?? Date())
        _label = State(initialValue: alarm?.label ?? "Wake Up")
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    // Time Picker Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("TIME")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .tracking(1.2)
                            .foregroundStyle(.secondary)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.primary.opacity(0.04))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                )
                            
                            #if os(iOS)
                            DatePicker(
                                "Alarm Time",
                                selection: $selectedTime,
                                displayedComponents: .hourAndMinute
                            )
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, maxHeight: 160)
                            .clipped()
                            #elseif os(macOS)
                            HStack {
                                Spacer()
                                DatePicker(
                                    "",
                                    selection: $selectedTime,
                                    displayedComponents: .hourAndMinute
                                )
                                .datePickerStyle(.stepperField)
                                .labelsHidden()
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                Spacer()
                            }
                            .padding(.vertical, 16)
                            #endif
                        }
                    }
                    
                    // Label Input Card
                    VStack(alignment: .leading, spacing: 8) {
                        Text("LABEL")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .tracking(1.2)
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "tag.fill")
                                .foregroundStyle(.blue)
                            
                            TextField("Alarm Label (e.g. Work, Workout)", text: $label)
                                .textFieldStyle(.plain)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.primary.opacity(0.04))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                )
                        )
                    }
                    
                    // Sound Settings Card
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SOUND")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .tracking(1.2)
                            .foregroundStyle(.secondary)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "speaker.wave.3.fill")
                                    .foregroundStyle(.blue)
                                Text("Alarm Sound")
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                Spacer()
                                Text("Crisp Alarm Beep")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }
                            
                            Divider()
                                .overlay(Color.primary.opacity(0.06))
                            
                            Button {
                                SoundManager.shared.playPreview()
                            } label: {
                                HStack {
                                    Image(systemName: "play.circle.fill")
                                    Text("Preview Alarm Tone")
                                }
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundStyle(.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.primary.opacity(0.04))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                )
                        )
                    }
                    
                    // Challenge Info Notice Card
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "keyboard.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Compulsory Typing Challenge")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundStyle(.primary)
                            
                            Text("When this alarm triggers, audio loops continuously until you type a randomized phrase accurately.")
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.08), Color.purple.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.15)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle(existingAlarm == nil ? "Add Alarm" : "Edit Alarm")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(selectedTime, label)
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
                }
            }
        }
        #if os(macOS)
        .frame(width: 440, height: 520)
        #elseif os(iOS)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        #endif
    }
}

#Preview {
    AlarmEditSheet { _, _ in }
}
