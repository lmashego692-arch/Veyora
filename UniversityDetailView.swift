//
//  UniversityDetailView.swift
//  Veyora
//
//  Created by Lesego Mashego on 2026/10/17.
//

import SwiftUI

struct University: Identifiable, Comparable {
    let id = UUID()
    let name: String
    let abbreviation: String
    let openDate: Date
    let closeDate: Date
    let earlyCloseDate: Date?
    let earlyCloseProgram: String?
    let officialLink: String
    let description: String
    
    // Evaluates the active deadline (checks if early closing date is sooner)
    var activeDeadline: Date {
        if let early = earlyCloseDate, early > Date() {
            return early < closeDate ? early : closeDate
        }
        return closeDate
    }
    
    // Checks against the user's phone date
    var isOpen: Bool {
        let now = Date()
        let deadline = earlyCloseDate ?? closeDate
        return now >= openDate && now <= deadline
    }
    
    // Calculates days remaining until closing
    var daysRemaining: Int {
        let now = Date()
        let deadline = earlyCloseDate ?? closeDate
        let components = Calendar.current.dateComponents([.day], from: now, to: deadline)
        return max(0, components.day ?? 0)
    }
    
    static func < (lhs: University, rhs: University) -> Bool {
        lhs.closeDate < rhs.closeDate
    }
}

struct UniversityDetailView: View {
    let university: University
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(university.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Divider()
                        .background(.gray)
                    
                    Group {
                        InfoRow(title: "Status", value: university.isOpen ? "Open" : "Closed", valueColor: university.isOpen ? .green : .red)
                        InfoRow(title: "Opening Date", value: formatDate(university.openDate))
                        InfoRow(title: "Regular Closing Date", value: formatDate(university.closeDate))
                        
                        if let earlyDate = university.earlyCloseDate, let program = university.earlyCloseProgram {
                            InfoRow(title: "Early Closing Date", value: formatDate(earlyDate))
                            InfoRow(title: "Early Programs", value: program)
                        }
                    }
                    
                    Spacer(minLength: 20)
                    
                    Text("University Information")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text(university.description)
                        .font(.body)
                        .foregroundStyle(.gray)
                    
                    Spacer(minLength: 30)
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("University Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    var valueColor: Color = .white
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.gray)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(valueColor)
                .multilineTextAlignment(.trailing)
        }
    }
}

