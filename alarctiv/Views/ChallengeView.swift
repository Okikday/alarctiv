//
//  ChallengeView.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import SwiftUI

struct ChallengeView: View {
    let alarm: Alarm
    let onCompleted: () -> Void
    
    @State private var challengeVM: ChallengeViewModel = ChallengeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Ringing Status Header
                VStack(spacing: 12) {
                    HStack(spacing: 10) {
                        Image(systemName: "alarm.waves.left.and.right.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.red)
                        
                        SoundWaveIndicator()
                    }
                    
                    Text("ALARM RINGING")
                        .font(.system(size: 13, weight: .black, design: .rounded))
                        .tracking(2)
                        .foregroundStyle(.red)
                    
                    Text(alarm.label)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("Audio is locked on loop. Type the randomized text below to silence it!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                .padding(.top, 20)
                
                // Typing Card
                TypingCardView(challengeVM: challengeVM)
                
                // Shuffle Phrase Option (in case of keyboard glitch, resets input)
                Button {
                    withAnimation {
                        challengeVM.reset()
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        Text("Get Different Phrase")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                
                Spacer(minLength: 20)
                
                // The Stop Button: Strictly locked until challenge passes!
                VStack(spacing: 8) {
                    PrimaryButton(
                        challengeVM.isExactMatch ? "I Am Awake (Stop Alarm)" : "Type Phrase To Silence Alarm",
                        systemImage: challengeVM.isExactMatch ? "bell.slash.fill" : "lock.fill",
                        style: challengeVM.isExactMatch ? .success : .destructive,
                        isEnabled: challengeVM.isExactMatch
                    ) {
                        onCompleted()
                    }
                    
                    if !challengeVM.isExactMatch {
                        Text("Button remains locked until 100% matched")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
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
        .onChange(of: challengeVM.isCompleted) { _, completed in
            if completed {
                // Auto-trigger completion or let user click the unlocked button
                #if os(iOS)
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                #endif
            }
        }
    }
}

#Preview {
    ChallengeView(
        alarm: Alarm(time: Date(), label: "Time To Wake Up!", isEnabled: true),
        onCompleted: {}
    )
}
