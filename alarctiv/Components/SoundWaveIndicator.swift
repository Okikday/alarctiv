//
//  SoundWaveIndicator.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import SwiftUI

struct SoundWaveIndicator: View {
    @State private var isAnimating = false
    
    private let barCount = 5
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<barCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 3)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(width: 4, height: isAnimating ? randomHeight(for: index) : 8)
                    .animation(
                        Animation.easeInOut(duration: 0.35)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.08),
                        value: isAnimating
                    )
            }
        }
        .frame(height: 32)
        .onAppear {
            isAnimating = true
        }
    }
    
    private func randomHeight(for index: Int) -> CGFloat {
        let heights: [CGFloat] = [28, 16, 32, 20, 26]
        return heights[index % heights.count]
    }
}

#Preview {
    SoundWaveIndicator()
        .padding()
        .background(Color.black)
}
