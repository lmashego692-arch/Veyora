//
//  Settings Page.swift
//  Veyora
//
//  Created by Lesego Mashego on 2026/10/16.
//

import SwiftUI

struct Settings_Page: View {
    var body: some View {
        VStack(spacing: 20) {
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text("Manage your app preferences and profile info here!")
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.ignoresSafeArea())
            }
        }

#Preview {
    Settings_Page()
}
