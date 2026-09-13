//
//  PrimaryButton.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import SwiftUI

enum PrimaryButtonStyle {
    case standard
    case success
    case destructive
}

struct PrimaryButton: View {
    let title: String
    let systemImage: String?
    var style: PrimaryButtonStyle = .standard
    var isEnabled: Bool = true
    let action: () -> Void
    
    init(
        _ title: String,
        systemImage: String? = nil,
        style: PrimaryButtonStyle = .standard,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.style = style
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 16, weight: .bold))
                }
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .foregroundStyle(foregroundColor)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: shadowColor, radius: isEnabled ? 8 : 0, y: isEnabled ? 4 : 0)
        }
        .disabled(!isEnabled)
        .buttonStyle(.plain)
    }
    
    private var foregroundColor: Color {
        guard isEnabled else { return .secondary }
        return .white
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        if !isEnabled {
            Color.primary.opacity(0.08)
        } else {
            switch style {
            case .standard:
                LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
            case .success:
                LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
            case .destructive:
                LinearGradient(colors: [.red, Color(red: 0.8, green: 0.1, blue: 0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
            }
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .standard:
            return Color.blue.opacity(0.35)
        case .success:
            return Color.green.opacity(0.3)
        case .destructive:
            return Color.red.opacity(0.3)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton("I Am Awake (Stop Alarm)", systemImage: "bell.slash.fill", style: .destructive, isEnabled: false) {}
        PrimaryButton("I Am Awake (Stop Alarm)", systemImage: "bell.slash.fill", style: .success, isEnabled: true) {}
        PrimaryButton("Set New Alarm", systemImage: "plus", style: .standard, isEnabled: true) {}
    }
    .padding()
}
