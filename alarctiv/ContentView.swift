//
//  ContentView.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = AlarmViewModel()
    
    var body: some View {
        ZStack {
            AlarmListView(viewModel: viewModel)
            
            // Active Alarm Challenge Overlay
            if viewModel.isChallengeActive, let activeAlarm = viewModel.activeAlarm {
                ChallengeView(alarm: activeAlarm) {
                    viewModel.completeAndDismissAlarm()
                }
                .transition(.asymmetric(insertion: .scale(scale: 0.95).combined(with: .opacity), removal: .opacity))
                .zIndex(10)
            }
            
            // Success Wake-up Overlay
            if viewModel.isSuccessPresented {
                SuccessDismissView {
                    withAnimation {
                        viewModel.isSuccessPresented = false
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(20)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.isChallengeActive)
        .animation(.easeInOut(duration: 0.25), value: viewModel.isSuccessPresented)
    }
}

#Preview {
    ContentView()
}
