//
//  ContentView.swift
//  Veyora
//
//  Created by Lesego Mashego on 2026/10/16.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("buttonPress") private var buttonPress = 0
        @State private var selectedTab = 0 // Tracks the active page
        
        var body: some View {
            ZStack(alignment: .bottom) {
                // 1. Clean, separate view files with a smooth fade transition
                Group {
                    if selectedTab == 0 {
                        Home_View() // Calls your new Home view file
                    } else if selectedTab == 1 {
                        APS_Tracker()
                    } else if selectedTab == 2 {
                        Calendar___Deadlines_Page()
                    } else if selectedTab == 3 {
                        Bursary_Page()
                    } else if selectedTab == 4 {
                        Settings_Page()
                    }
                }
                .transition(.opacity) // Simplified fade transition eliminates lag
                .id(selectedTab)
                 
                // 2. Permanent Floating Capsule Toolbar at the Bottom
                HStack(spacing: 28) {
                    toolbarButton(index: 0, icon: "house.fill")
                    toolbarButton(index: 1, icon: "chart.line.uptrend.xyaxis")
                    toolbarButton(index: 2, icon: "calendar.badge.clock")
                    toolbarButton(index: 3, icon: "graduationcap.fill")
                    toolbarButton(index: 4, icon: "gearshape.fill")
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                .padding(.bottom, 16)
            }
            .preferredColorScheme(.dark)
        }
        
        @ViewBuilder
        private func toolbarButton(index: Int, icon: String) -> some View {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = index
                }
            }) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(selectedTab == index ? .blue : .primary)
                    .scaleEffect(selectedTab == index ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: selectedTab)
            }
        }
    }


#Preview {
    ContentView()
}
