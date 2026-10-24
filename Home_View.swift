//
//  Home_View.swift
//  Veyora
//
//  Created by Lesego Mashego on 2026/10/17.
//

import SwiftUI

// MARK: - Shared NBT Data Models

struct NBTScoreData: Codable {
    var alScore: Int = 0
    var qlScore: Int = 0
    var matScore: Int = 0
}

enum NBTBenchmarkTier: String {
    case basic = "Basic"
    case intermediateLower = "Intermediate Lower"
    case intermediateUpper = "Intermediate Upper"
    case proficient = "Proficient"
    
    var color: Color {
        switch self {
        case .basic: return .red
        case .intermediateLower: return .orange
        case .intermediateUpper: return .yellow
        case .proficient: return .green
        }
    }
}

// MARK: - Home_View

struct Home_View: View {
    @AppStorage("savedSubjectsJSON") private var savedSubjectsData: Data = Data()
    @AppStorage("savedNBTJSON") private var savedNBTData: Data = Data()
    
    @State private var showUniCalculatorSheet = false
    @State private var showNBTCalculatorSheet = false
    @State private var showNBTCalendarSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue, .black], startPoint: .bottomLeading, endPoint: .topTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header Greeting
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hello! Welcome to Veroya")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.8))
                            Text("Dashboard")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // APS Quick Summary Hero Card
                        let subjects = loadSubjects()
                        let standardAPS = calculateStandardAPS(from: subjects)
                        
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("STANDARD APS SCORE")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white.opacity(0.7))
                                    Text("\(standardAPS)")
                                        .font(.system(size: 38, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("TRACKED SUBJECTS")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white.opacity(0.7))
                                    Text("\(subjects.count) Loaded")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                }
                            }
                            
                            Divider().background(Color.white.opacity(0.2))
                            
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundStyle(.white.opacity(0.8))
                                Text("Top 6 subjects (excluding Life Orientation)")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.8))
                                Spacer()
                            }
                        }
                        .padding(16)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        // Core Tools Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("University & Exam Tools")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(.horizontal)
                            
                            // 1. Custom Uni Score Calculator Button
                            Button(action: { showUniCalculatorSheet = true }) {
                                HStack(spacing: 14) {
                                    Image(systemName: "function")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                        .frame(width: 44, height: 44)
                                        .background(Color.white.opacity(0.15))
                                        .cornerRadius(12)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Custom Admission Scores")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        Text("Convert marks for SU, UCT, Wits, NMU, NWU, UWC & CPUT")
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.7))
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                                .padding(14)
                                .background(Color.white.opacity(0.08))
                                .cornerRadius(16)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                            
                            // 2. NBT Score Calculator & Proficiency Button
                            Button(action: { showNBTCalculatorSheet = true }) {
                                HStack(spacing: 14) {
                                    Image(systemName: "chart.bar.doc.horizontal.fill")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                        .frame(width: 44, height: 44)
                                        .background(Color.white.opacity(0.15))
                                        .cornerRadius(12)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("NBT Score & Proficiency")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        Text("Enter AL, QL & MAT scores to view performance tiers")
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.7))
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                                .padding(14)
                                .background(Color.white.opacity(0.08))
                                .cornerRadius(16)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                            
                            // 3. NBT Calendar & Schedule Button
                            Button(action: { showNBTCalendarSheet = true }) {
                                HStack(spacing: 14) {
                                    Image(systemName: "calendar.badge.clock")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                        .frame(width: 44, height: 44)
                                        .background(Color.white.opacity(0.15))
                                        .cornerRadius(12)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("NBT Test Calendar & Fees")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        Text("View all test dates, deadlines, online/paper schedules & costs")
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.7))
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                                .padding(14)
                                .background(Color.white.opacity(0.08))
                                .cornerRadius(16)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Veroya")
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showUniCalculatorSheet) {
                UniCalculationsSheetView(subjects: loadSubjects())
            }
            .sheet(isPresented: $showNBTCalculatorSheet) {
                NBTCalculatorSheetView()
            }
            .sheet(isPresented: $showNBTCalendarSheet) {
                NBTCalendarSheetView()
            }
        }
    }
    
    private func loadSubjects() -> [SubjectScore] {
        if let decoded = try? JSONDecoder().decode([SubjectScore].self, from: savedSubjectsData) {
            return decoded
        }
        return []
    }
    
    private func calculateStandardAPS(from subjects: [SubjectScore]) -> Int {
        let valid = subjects.filter { $0.name != "Life Orientation" }
        let sorted = valid.map { $0.apsLevel }.sorted(by: >)
        return sorted.prefix(6).reduce(0, +)
    }
}

// MARK: - 1. Custom University Calculations Sheet

struct UniCalculationsSheetView: View {
    let subjects: [SubjectScore]
    @Environment(\.dismiss) var dismiss
    @State private var isQuintile1to3 = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if subjects.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.orange)
                            Text("No Subjects Found")
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text("Please add your subjects in the APS Tracker tab first to convert your admission scores.")
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 40)
                        .padding(.horizontal)
                    } else {
                        Text("Custom University Scores")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        
                        UniScoreCard(
                            uniName: "Stellenbosch University (SU)",
                            scoreTitle: "Tuned Points Total (TPT) / NSC Average",
                            scoreValue: String(format: "%.2f%%", calculateSU_TPT()),
                            formulaDetail: "Average of Language of Learning + 5 best 20-credit subjects (excl. LO & AP Math).\nEngineering/Science TPT: \(String(format: "%.2f%%", calculateSU_Engineering()))"
                        )
                        
                        UniScoreCard(
                            uniName: "University of Cape Town (UCT)",
                            scoreTitle: "Faculty Points Score (FPS)",
                            scoreValue: "\(calculateUCT_FPS()) / 600",
                            formulaDetail: "Sum of 6 best NSC subjects (excl. LO & AP Math).\nScience Faculty FPS (out of 800): \(calculateUCT_ScienceFPS())"
                        )
                        
                        UniScoreCard(
                            uniName: "University of the Witwatersrand (Wits)",
                            scoreTitle: "Wits Custom APS Score",
                            scoreValue: "\(calculateWitsScore()) / 60",
                            formulaDetail: "Uses 7 subjects including LO (LO capped at 4 pts). +2 bonus points added for English & Math if mark ≥ 60%."
                        )
                        
                        VStack(alignment: .leading, spacing: 10) {
                            UniScoreCard(
                                uniName: "Nelson Mandela University (NMU)",
                                scoreTitle: "Applicant Score (AS)",
                                scoreValue: "\(calculateNMUScore()) / 600",
                                formulaDetail: "Sum of raw percentages of top 6 subjects (excl. LO)." + (isQuintile1to3 ? " Includes +7 equity bonus." : "")
                            )
                            Toggle("Quintile 1, 2, or 3 School (+7 Equity Bonus)", isOn: $isQuintile1to3)
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .padding(.horizontal, 8)
                        }
                        
                        UniScoreCard(
                            uniName: "North-West University (NWU)",
                            scoreTitle: "NWU 8-Point Scale Total",
                            scoreValue: "\(calculateNWUScore()) / 48",
                            formulaDetail: "Top 6 subjects (excl. LO) mapped to custom 8-point scale (90%+ = 8 points)."
                        )
                        
                        UniScoreCard(
                            uniName: "University of the Western Cape (UWC)",
                            scoreTitle: "UWC Weighted Total",
                            scoreValue: "\(calculateUWCScore()) / 72",
                            formulaDetail: "7 subjects converted to 8-point scale, with English & Mathematics point values multiplied by 2."
                        )
                        
                        UniScoreCard(
                            uniName: "Cape Peninsula University of Technology (CPUT)",
                            scoreTitle: "CPUT Stream Total",
                            scoreValue: "\(calculateCPUTScore()) / 54",
                            formulaDetail: "Sum of 6 faculty-required subjects (excl. LO) using single-digit point mapping (mark ÷ 10)."
                        )
                    }
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Admission Calculations")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func getSubjectMark(_ name: String) -> Int? {
        subjects.first(where: { $0.name.lowercased().contains(name.lowercased()) })?.mark
    }
    
    private func calculateSU_TPT() -> Double {
        let valid = subjects.filter { $0.name != "Life Orientation" && !$0.name.contains("Advanced") }
        guard !valid.isEmpty else { return 0 }
        let langMark = valid.first(where: { $0.name.contains("English") || $0.name.contains("Afrikaans") })?.mark ?? 0
        let otherSubjects = valid.filter { !($0.name.contains("English") || $0.name.contains("Afrikaans")) }
        let top5Others = otherSubjects.map { $0.mark }.sorted(by: >).prefix(5)
        let sum = langMark + top5Others.reduce(0, +)
        let count = 1 + top5Others.count
        return count > 0 ? Double(sum) / Double(count) : 0
    }
    
    private func calculateSU_Engineering() -> Double {
        let valid = subjects.filter { $0.name != "Life Orientation" && !$0.name.contains("Advanced") }
        let mathMark = getSubjectMark("Mathematics") ?? 0
        let others = valid.filter { $0.name != "Mathematics" }.map { $0.mark }.sorted(by: >).prefix(5)
        let total = (mathMark * 2) + others.reduce(0, +)
        return Double(total) / 7.0
    }
    
    private func calculateUCT_FPS() -> Int {
        let valid = subjects.filter { $0.name != "Life Orientation" && !$0.name.contains("Advanced") }
        let sortedMarks = valid.map { $0.mark < 40 ? 0 : $0.mark }.sorted(by: >)
        return sortedMarks.prefix(6).reduce(0, +)
    }
    
    private func calculateUCT_ScienceFPS() -> Int {
        let baseFPS = calculateUCT_FPS()
        let math = getSubjectMark("Mathematics") ?? 0
        let phys = getSubjectMark("Physical Sciences") ?? 0
        return baseFPS + math + phys
    }
    
    private func calculateWitsScore() -> Int {
        var total = 0
        for sub in subjects.prefix(7) {
            let isLO = sub.name == "Life Orientation"
            let m = sub.mark
            var points = 0
            switch m {
            case 90...100: points = isLO ? 4 : 8
            case 80...89:  points = isLO ? 3 : 7
            case 70...79:  points = isLO ? 2 : 6
            case 60...69:  points = isLO ? 1 : 5
            case 50...59:  points = isLO ? 0 : 4
            case 40...49:  points = isLO ? 0 : 3
            default:       points = 0
            }
            if (sub.name.contains("English") || sub.name.contains("Mathematics")) && m >= 60 {
                points += 2
            }
            total += points
        }
        return total
    }
    
    private func calculateNMUScore() -> Int {
        let valid = subjects.filter { $0.name != "Life Orientation" }
        let sorted = valid.map { $0.mark }.sorted(by: >).prefix(6)
        let base = sorted.reduce(0, +)
        return base + (isQuintile1to3 ? 7 : 0)
    }
    
    private func calculateNWUScore() -> Int {
        let valid = subjects.filter { $0.name != "Life Orientation" }
        let top6 = valid.map { $0.mark }.sorted(by: >).prefix(6)
        return top6.map { m -> Int in
            switch m {
            case 90...100: return 8
            case 80...89:  return 7
            case 70...79:  return 6
            case 60...69:  return 5
            case 50...59:  return 4
            case 40...49:  return 3
            case 30...39:  return 2
            default:       return 1
            }
        }.reduce(0, +)
    }
    
    private func calculateUWCScore() -> Int {
        var total = 0
        for sub in subjects.prefix(7) {
            let m = sub.mark
            var pts = 0
            switch m {
            case 90...100: pts = 8
            case 80...89:  pts = 7
            case 70...79:  pts = 6
            case 60...69:  pts = 5
            case 50...59:  pts = 4
            case 40...49:  pts = 3
            case 30...39:  pts = 2
            default:       pts = 1
            }
            if sub.name.contains("English") || sub.name.contains("Math") {
                pts *= 2
            }
            total += pts
        }
        return total
    }
    
    private func calculateCPUTScore() -> Int {
        let valid = subjects.filter { $0.name != "Life Orientation" }
        let top6 = valid.map { $0.mark }.sorted(by: >).prefix(6)
        return top6.map { m -> Int in
            switch m {
            case 90...100: return 9
            case 80...89:  return 8
            case 70...79:  return 7
            case 60...69:  return 6
            case 50...59:  return 5
            case 40...49:  return 4
            case 30...39:  return 3
            case 20...29:  return 2
            default:       return 1
            }
        }.reduce(0, +)
    }
}

struct UniScoreCard: View {
    let uniName: String
    let scoreTitle: String
    let scoreValue: String
    let formulaDetail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(uniName)
                .font(.headline)
                .foregroundStyle(.blue)
            
            HStack {
                Text(scoreTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
                Spacer()
                Text(scoreValue)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.green)
            }
            
            Text(formulaDetail)
                .font(.caption2)
                .foregroundStyle(.gray.opacity(0.8))
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - 2. NBT Calculator & Proficiency Sheet

struct NBTCalculatorSheetView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("savedNBTJSON") private var savedNBTData: Data = Data()
    
    @State private var alScoreString: String = ""
    @State private var qlScoreString: String = ""
    @State private var matScoreString: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Enter Official Percentage Scores") {
                    HStack {
                        Text("Academic Literacy (AL)")
                        Spacer()
                        TextField("%", text: $alScoreString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                    }
                    HStack {
                        Text("Quantitative Literacy (QL)")
                        Spacer()
                        TextField("%", text: $qlScoreString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                    }
                    HStack {
                        Text("Mathematics (MAT)")
                        Spacer()
                        TextField("%", text: $matScoreString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                    }
                }
                
                Section("Evaluated Performance Tiers") {
                    let al = Int(alScoreString) ?? 0
                    let ql = Int(qlScoreString) ?? 0
                    let mat = Int(matScoreString) ?? 0
                    
                    NBTTierResultRow(subject: "Academic Literacy (AL)", score: al, tier: evaluateAL(al))
                    NBTTierResultRow(subject: "Quantitative Literacy (QL)", score: ql, tier: evaluateQL(ql))
                    NBTTierResultRow(subject: "Mathematics (MAT)", score: mat, tier: evaluateMAT(mat))
                }
                
                Section("Official Benchmark Criteria") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("• Proficient: AL (70%+), QL (70%+), MAT (69%+)")
                        Text("• Intermediate Upper: AL (55–69%), QL (55–69%), MAT (52–68%)")
                        Text("• Intermediate Lower: AL (40–54%), QL (40–54%), MAT (35–51%)")
                        Text("• Basic: AL (<40%), QL (<40%), MAT (<35%)")
                    }
                    .font(.caption2)
                    .foregroundStyle(.gray)
                }
            }
            .navigationTitle("NBT Evaluator")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save & Close") {
                        saveNBTScores()
                        dismiss()
                    }
                }
            }
            .onAppear { loadNBTScores() }
        }
        .preferredColorScheme(.dark)
    }
    
    private func evaluateAL(_ mark: Int) -> NBTBenchmarkTier {
        switch mark {
        case 70...100: return .proficient
        case 55...69:  return .intermediateUpper
        case 40...54:  return .intermediateLower
        default:       return .basic
        }
    }
    
    private func evaluateQL(_ mark: Int) -> NBTBenchmarkTier {
        switch mark {
        case 70...100: return .proficient
        case 55...69:  return .intermediateUpper
        case 40...54:  return .intermediateLower
        default:       return .basic
        }
    }
    
    private func evaluateMAT(_ mark: Int) -> NBTBenchmarkTier {
        switch mark {
        case 69...100: return .proficient
        case 52...68:  return .intermediateUpper
        case 35...51:  return .intermediateLower
        default:       return .basic
        }
    }
    
    private func saveNBTScores() {
        let nbt = NBTScoreData(
            alScore: Int(alScoreString) ?? 0,
            qlScore: Int(qlScoreString) ?? 0,
            matScore: Int(matScoreString) ?? 0
        )
        if let encoded = try? JSONEncoder().encode(nbt) {
            savedNBTData = encoded
        }
    }
    
    private func loadNBTScores() {
        if let decoded = try? JSONDecoder().decode(NBTScoreData.self, from: savedNBTData) {
            alScoreString = decoded.alScore > 0 ? "\(decoded.alScore)" : ""
            qlScoreString = decoded.qlScore > 0 ? "\(decoded.qlScore)" : ""
            matScoreString = decoded.matScore > 0 ? "\(decoded.matScore)" : ""
        }
    }
}

struct NBTTierResultRow: View {
    let subject: String
    let score: Int
    let tier: NBTBenchmarkTier
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(subject)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                Text("Score: \(score)%")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            Spacer()
            Text(tier.rawValue)
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(tier.color.opacity(0.2))
                .foregroundStyle(tier.color)
                .cornerRadius(8)
        }
    }
}

// MARK: - 3. NBT Test Calendar & Schedule Sheet

struct NBTDateEntry: Identifiable {
    let id = UUID()
    let testDate: String
    let regDeadline: String
    let payDeadline: String
    let instResults: String
    let writerResults: String
    let isSunday: Bool
    let isOnline: Bool
}

struct NBTCalendarSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    let nbtSchedule: [NBTDateEntry] = [
        NBTDateEntry(testDate: "9-May", regDeadline: "19-Apr", payDeadline: "27-Apr", instResults: "01-Jun", writerResults: "08-Jun", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "16-May", regDeadline: "26-Apr", payDeadline: "04-May", instResults: "08-Jun", writerResults: "15-Jun", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "30-May", regDeadline: "10-May", payDeadline: "18-May", instResults: "22-Jun", writerResults: "29-Jun", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "6-Jun", regDeadline: "17-May", payDeadline: "25-May", instResults: "29-Jun", writerResults: "06-Jul", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "7-Jun", regDeadline: "17-May", payDeadline: "25-May", instResults: "29-Jun", writerResults: "06-Jul", isSunday: true, isOnline: false),
        NBTDateEntry(testDate: "20-Jun", regDeadline: "31-May", payDeadline: "08-Jun", instResults: "13-Jul", writerResults: "20-Jul", isSunday: false, isOnline: true),
        NBTDateEntry(testDate: "27-Jun", regDeadline: "7-Jun", payDeadline: "15-Jun", instResults: "20-Jul", writerResults: "27-Jul", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "4-Jul", regDeadline: "15-Jun", payDeadline: "22-Jun", instResults: "27-Jul", writerResults: "03-Aug", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "5-Jul", regDeadline: "15-Jun", payDeadline: "22-Jun", instResults: "27-Jul", writerResults: "03-Aug", isSunday: true, isOnline: false),
        NBTDateEntry(testDate: "11-Jul", regDeadline: "21-Jun", payDeadline: "29-Jun", instResults: "03-Aug", writerResults: "10-Aug", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "18-Jul", regDeadline: "28-Jun", payDeadline: "06-Jul", instResults: "10-Aug", writerResults: "17-Aug", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "25-Jul", regDeadline: "5-Jul", payDeadline: "13-Jul", instResults: "17-Aug", writerResults: "24-Aug", isSunday: false, isOnline: true),
        NBTDateEntry(testDate: "1-Aug", regDeadline: "12-Jul", payDeadline: "20-Jul", instResults: "24-Aug", writerResults: "31-Aug", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "2-Aug", regDeadline: "12-Jul", payDeadline: "20-Jul", instResults: "24-Aug", writerResults: "31-Aug", isSunday: true, isOnline: false),
        NBTDateEntry(testDate: "15-Aug", regDeadline: "26-Jul", payDeadline: "03-Aug", instResults: "07-Sep", writerResults: "14-Sep", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "22-Aug", regDeadline: "2-Aug", payDeadline: "10-Aug", instResults: "14-Sep", writerResults: "21-Sep", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "29-Aug", regDeadline: "9-Aug", payDeadline: "17-Aug", instResults: "21-Sep", writerResults: "28-Sep", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "5-Sep", regDeadline: "16-Aug", payDeadline: "24-Aug", instResults: "28-Sep", writerResults: "05-Oct", isSunday: false, isOnline: true),
        NBTDateEntry(testDate: "12-Sep", regDeadline: "23-Aug", payDeadline: "31-Aug", instResults: "05-Oct", writerResults: "12-Oct", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "26-Sep", regDeadline: "6-Sep", payDeadline: "14-Sep", instResults: "19-Oct", writerResults: "26-Oct", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "3-Oct", regDeadline: "13-Sep", payDeadline: "21-Sep", instResults: "26-Oct", writerResults: "02-Nov", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "10-Oct", regDeadline: "20-Sep", payDeadline: "28-Sep", instResults: "02-Nov", writerResults: "09-Nov", isSunday: false, isOnline: false),
        NBTDateEntry(testDate: "9-Jan", regDeadline: "6-Dec", payDeadline: "14-Dec", instResults: "01-Feb", writerResults: "08-Feb", isSunday: false, isOnline: false)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Official Fee Structure")
                            .font(.headline)
                            .foregroundStyle(.white)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("AQL Test Only").font(.caption).foregroundStyle(.gray)
                                Text("R195").font(.title3).fontWeight(.bold).foregroundStyle(.blue)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("AQL & MAT Tests").font(.caption).foregroundStyle(.gray)
                                Text("R390").font(.title3).fontWeight(.bold).foregroundStyle(.green)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Re-Mark Fee").font(.caption).foregroundStyle(.gray)
                                Text("R250").font(.title3).fontWeight(.bold).foregroundStyle(.orange)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(12)
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Circle().fill(Color.green).frame(width: 10, height: 10)
                            Text("Sunday Session").font(.caption2).foregroundStyle(.gray)
                        }
                        HStack(spacing: 6) {
                            Circle().fill(Color.yellow).frame(width: 10, height: 10)
                            Text("Online Session").font(.caption2).foregroundStyle(.gray)
                        }
                    }
                    .padding(.horizontal, 4)
                    
                    VStack(spacing: 10) {
                        ForEach(nbtSchedule) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack {
                                        Text(item.testDate).font(.headline).foregroundStyle(.white)
                                        if item.isSunday {
                                            Text("Sunday").font(.caption2).fontWeight(.bold).padding(.horizontal, 6).padding(.vertical, 2).background(Color.green.opacity(0.2)).foregroundStyle(.green).cornerRadius(4)
                                        }
                                        if item.isOnline {
                                            Text("Online").font(.caption2).fontWeight(.bold).padding(.horizontal, 6).padding(.vertical, 2).background(Color.yellow.opacity(0.2)).foregroundStyle(.yellow).cornerRadius(4)
                                        }
                                    }
                                    Text("Reg Closes: \(item.regDeadline) | Pay Closes: \(item.payDeadline)").font(.caption).foregroundStyle(.gray)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("Results:").font(.caption2).foregroundStyle(.gray)
                                    Text(item.writerResults).font(.caption).fontWeight(.semibold).foregroundStyle(.blue)
                                }
                            }
                            .padding(12)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("NBT Calendar & Schedule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    Home_View()
}
