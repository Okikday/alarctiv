//
//  SuccessDismissView.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import SwiftUI

struct SuccessDismissView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.12))
                    .frame(width: 120, height: 120)
                
                Circle()
                    .fill(Color.green.opacity(0.25))
                    .frame(width: 90, height: 90)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundStyle(.green)
            }
            
            VStack(spacing: 10) {
                Text("Alarm Silenced!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text("You conquered the typing challenge.")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Text("Your brain is officially awake and energized for the day ahead.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            PrimaryButton(
                "Start Your Day",
                systemImage: "sun.max.fill",
                style: .success,
                isEnabled: true
            ) {
                onDismiss()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            #if os(iOS)
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            #elseif os(macOS)
            Color(nsColor: .windowBackgroundColor)
                .ignoresSafeArea()
            #endif
        }
    }
}

#Preview {
    SuccessDismissView {}
}
