//
//  AlarmListView.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import SwiftUI

struct AlarmListView: View {
    @Bindable var viewModel: AlarmViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Live Digital Clock
                    DigitalClockView()
                        .padding(.top, 8)
                    
                    // Quick Drill / Test Challenge Button
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Label("Quick Drill", systemImage: "bolt.fill")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .tracking(1)
                                .foregroundStyle(.blue)
                            
                            Spacer()
                        }
                        
                        Button {
                            viewModel.triggerInstantTest()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "play.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Test Wake-Up Challenge Now")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.primary)
                                    
                                    Text("Rings the alarm audio and triggers the typing challenge instantly.")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.06)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.2)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // Alarms List Section
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("YOUR ALARMS")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .tracking(1)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text("\(viewModel.alarms.filter { $0.isEnabled }.count) Active")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.blue)
                        }
                        
                        if viewModel.alarms.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "alarm")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.secondary.opacity(0.5))
                                    .padding(.top, 16)
                                
                                Text("No Alarms Scheduled")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                
                                Text("Tap the '+' button above to add an alarm.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary.opacity(0.8))
                                
                                Button("Create Your First Alarm") {
                                    viewModel.showingAddSheet = true
                                }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.blue)
                                .padding(.top, 4)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.primary.opacity(0.03))
                            )
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.alarms) { alarm in
                                    AlarmCardView(
                                        alarm: alarm,
                                        onToggle: {
                                            viewModel.toggleAlarm(id: alarm.id)
                                        },
                                        onEdit: {
                                            viewModel.editingAlarm = alarm
                                        },
                                        onDelete: {
                                            viewModel.deleteAlarm(id: alarm.id)
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .navigationTitle("Alarctiv")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddSheet) {
                AlarmEditSheet { newTime, newLabel in
                    viewModel.addAlarm(time: newTime, label: newLabel)
                }
            }
            .sheet(item: $viewModel.editingAlarm) { alarmToEdit in
                AlarmEditSheet(alarm: alarmToEdit) { updatedTime, updatedLabel in
                    var updated = alarmToEdit
                    updated.time = updatedTime
                    updated.label = updatedLabel
                    viewModel.updateAlarm(updated)
                }
            }
        }
    }
}

#Preview {
    AlarmListView(viewModel: AlarmViewModel())
}
