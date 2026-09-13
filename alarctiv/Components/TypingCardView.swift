//
//  TypingCardView.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import SwiftUI

struct TypingCardView: View {
    @Bindable var challengeVM: ChallengeViewModel
    @FocusState private var isFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            // Target Phrase Display with live character highlights
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("TYPE THIS EXACTLY:")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(1.2)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(challengeVM.progress * 100))%")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(challengeVM.isExactMatch ? Color.green : Color.blue)
                        .monospacedDigit()
                }
                
                // Progress Bar
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.primary.opacity(0.1))
                            .frame(height: 6)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: challengeVM.isExactMatch ? [.green, .mint] : [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(0, proxy.size.width * challengeVM.progress), height: 6)
                            .animation(.easeOut(duration: 0.15), value: challengeVM.progress)
                    }
                }
                .frame(height: 6)
                
                // Target sentence with character-by-character color formatting
                formattedTargetText
                    .padding(.top, 6)
            }
            
            Divider()
                .overlay(Color.primary.opacity(0.1))
            
            // Interactive Typing Input Area
            VStack(alignment: .leading, spacing: 8) {
                Text("YOUR INPUT:")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .tracking(1.2)
                    .foregroundStyle(.secondary)
                
                ZStack(alignment: .leading) {
                    if challengeVM.userInput.isEmpty {
                        Text("Start typing here...")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary.opacity(0.5))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 14)
                    }
                    
                    TextField("", text: Binding(
                        get: { challengeVM.userInput },
                        set: { challengeVM.handleTextChange($0) }
                    ))
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .autocorrectionDisabled()
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.asciiCapable)
                    #endif
                    .padding(.vertical, 12)
                    .padding(.horizontal, 14)
                    .focused($isFieldFocused)
                }
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.primary.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(inputBorderColor, lineWidth: 1.5)
                        )
                }
            }
            
            // Anti-cheat warning
            if challengeVM.pasteBlockedWarning {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.yellow)
                    Text("No pasting allowed! You must physically type each key to wake up.")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.yellow)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.yellow.opacity(0.12))
                )
                .transition(.opacity.combined(with: .scale))
            }
            
            // Error indicator
            if challengeVM.hasErrors && !challengeVM.userInput.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                    Text("Mismatch detected! Check the highlighted red characters above.")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.red)
                }
                .transition(.opacity)
            }
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.primary.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(challengeVM.isExactMatch ? Color.green : Color.primary.opacity(0.1), lineWidth: 1.5)
                )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isFieldFocused = true
            }
        }
    }
    
    private var inputBorderColor: Color {
        if challengeVM.isExactMatch {
            return .green
        } else if challengeVM.hasErrors {
            return .red.opacity(0.7)
        } else if isFieldFocused {
            return .blue
        } else {
            return Color.primary.opacity(0.1)
        }
    }
    
    private var formattedTargetText: some View {
        let statuses = challengeVM.characterStatuses
        let chars = challengeVM.targetCharacters
        
        return Text(attributedString(chars: chars, statuses: statuses))
            .font(.system(size: 20, weight: .medium, design: .rounded))
            .lineSpacing(6)
    }
    
    private func attributedString(chars: [Character], statuses: [CharacterMatchStatus]) -> AttributedString {
        var result = AttributedString("")
        
        for (i, char) in chars.enumerated() {
            var charAttr = AttributedString(String(char))
            let status = (i < statuses.count) ? statuses[i] : .pending
            
            switch status {
            case .correct:
                charAttr.foregroundColor = .green
                charAttr.inlinePresentationIntent = .stronglyEmphasized
            case .incorrect:
                charAttr.foregroundColor = .red
                charAttr.backgroundColor = .red.opacity(0.2)
                charAttr.inlinePresentationIntent = .stronglyEmphasized
            case .currentCursor:
                charAttr.foregroundColor = .blue
                charAttr.underlineStyle = .single
            case .pending:
                charAttr.foregroundColor = .secondary.opacity(0.7)
            }
            result.append(charAttr)
        }
        
        return result
    }
}

#Preview {
    TypingCardView(challengeVM: ChallengeViewModel())
        .padding()
}
