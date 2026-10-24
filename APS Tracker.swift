//
//  APS Tracker.swift
//  Veyora
//
//  Created by Lesego Mashego on 2026/10/16.
//

import SwiftUI

// MARK: - Models & Persistent Storage

struct SubjectScore: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var mark: Int
    
    // Converts percentage to official South African APS Level (1-7)
    var apsLevel: Int {
        switch mark {
        case 80...100: return 7
        case 70...79:  return 6
        case 60...69:  return 5
        case 50...59:  return 4
        case 40...49:  return 3
        case 30...39:  return 2
        default:       return 1
        }
    }
}

// MARK: - Main APS Tracker View

struct APS_Tracker: View {
    @AppStorage("savedSubjectsJSON") private var savedSubjectsData: Data = Data()
    
    @State private var subjects: [SubjectScore] = []
    @State private var showingAddSheet = false
    @State private var selectedTab: TrackerTab = .track
    
    // Namespace for fluid matched geometry pill animation
    @Namespace private var tabNamespace
    
    // Matcher Selection States
    @State private var allUniversities: [UniversityModel] = []
    @State private var selectedUniversityName: String = ""
    @State private var selectedFacultyName: String = "All Faculties"
    @State private var isLoadingData = true
    
    enum TrackerTab: String, CaseIterable, Identifiable {
        case track = "Track"
        case match = "Match"
        var id: String { self.rawValue }
    }
    
    let availableSubjects = [
        "Mathematics",
        "Mathematical Literacy",
        "English Home Language",
        "English First Additional Language",
        "Afrikaans Home Language",
        "Afrikaans First Additional Language",
        "Physical Sciences",
        "Life Sciences",
        "Accounting",
        "Business Studies",
        "Economics",
        "History",
        "Geography",
        "Life Orientation",
        "Information Technology (IT)",
        "Computer Applications Tech (CAT)",
        "Engineering Graphics & Design (EGD)",
        "Agricultural Sciences",
        "Consumer Studies",
        "Visual Arts",
        "Dramatic Arts",
        "Music",
        "Tourism",
        "IsiZulu Home Language",
        "IsiZulu First Additional Language",
        "Sesotho Home Language",
        "Setswana Home Language"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // Animated Pill Picker Switcher (Track & Match)
                    HStack(spacing: 0) {
                        ForEach(TrackerTab.allCases) { tab in
                            Button(action: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                    selectedTab = tab
                                }
                            }) {
                                Text(tab.rawValue)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(
                                        ZStack {
                                            if selectedTab == tab {
                                                Capsule()
                                                    .fill(Color.white.opacity(0.18))
                                                    .overlay(
                                                        Capsule()
                                                            .stroke(Color.white.opacity(0.25), lineWidth: 0.5)
                                                    )
                                                    // Fluid sliding transition background effect
                                                    .matchedGeometryEffect(id: "ACTIVE_PILL", in: tabNamespace)
                                            }
                                        }
                                    )
                            }
                            // Button scale feedback press effect
                            .scaleEffect(selectedTab == tab ? 1.02 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedTab)
                        }
                    }
                    .padding(4)
                    .background(Capsule().fill(Color.white.opacity(0.08)))
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Animated Page Content Switching
                    ZStack {
                        if selectedTab == .track {
                            trackView
                                .transition(.asymmetric(
                                    insertion: .move(edge: .leading).combined(with: .opacity),
                                    removal: .move(edge: .trailing).combined(with: .opacity)
                                ))
                        } else {
                            matchView
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                        }
                    }
                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: selectedTab)
                }
            }
            .navigationTitle("APS Tracker")
            .preferredColorScheme(.dark)
            .toolbar {
                if selectedTab == .track {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { showingAddSheet = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddSubjectView(availableSubjects: availableSubjects, existingSubjects: subjects) { newSubject in
                    subjects.append(newSubject)
                    saveSubjects()
                }
            }
            .onAppear {
                loadSubjects()
                loadUniversityDataset()
            }
        }
    }
    
    // MARK: - Track View Tab
    
    private var trackView: some View {
        VStack(spacing: 20) {
            // APS Score Summary Header Card
            VStack(spacing: 8) {
                Text("Total APS Score")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                Text("\(calculateAPS())")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.blue)
                
                Text("Calculated from your top academic subjects")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .padding(.horizontal)
            
            // List of Added Subjects
            if subjects.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "book.closed")
                        .font(.system(size: 50))
                        .foregroundStyle(.gray)
                    Text("No subjects added yet.")
                        .foregroundStyle(.gray)
                    Text("Tap the '+' button below to add your subjects and marks.")
                        .font(.caption)
                        .foregroundStyle(.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                Spacer()
            } else {
                List {
                    ForEach($subjects) { $item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text("Level: \(item.apsLevel)")
                                    .font(.caption)
                                    .foregroundStyle(.blue)
                            }
                            
                            Spacer()
                            
                            HStack {
                                TextField("Mark", value: $item.mark, format: .number)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 50)
                                    .padding(6)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(8)
                                    .foregroundStyle(.white)
                                    .onChange(of: item.mark) {
                                        saveSubjects()
                                    }
                                
                                Text("%")
                                    .foregroundStyle(.gray)
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.05))
                    }
                    .onDelete(perform: deleteSubject)
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
    
    // MARK: - Match View Tab
    
    private var matchView: some View {
        VStack(spacing: 16) {
            if isLoadingData {
                Spacer()
                ProgressView("Loading University Requirements...")
                    .foregroundStyle(.gray)
                Spacer()
            } else if allUniversities.isEmpty {
                Spacer()
                Text("Unable to load course data.")
                    .foregroundStyle(.gray)
                Spacer()
            } else {
                // University & Faculty Selection Controls
                VStack(spacing: 12) {
                    // University Picker
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Select University")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Picker("University", selection: $selectedUniversityName) {
                            ForEach(allUniversities) { uni in
                                Text(uni.university).tag(uni.university)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(10)
                    }
                    
                    // Faculty Filter Picker
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Filter by Faculty")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Picker("Faculty", selection: $selectedFacultyName) {
                            Text("All Faculties").tag("All Faculties")
                            ForEach(availableFacultiesForSelectedUni, id: \.self) { faculty in
                                Text(faculty).tag(faculty)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                // Qualified & Unqualified Course Lists
                let evaluated = evaluatedCoursesForSelectedUniversity()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Qualified Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundStyle(.green)
                                Text("Qualified Courses (\(evaluated.qualified.count))")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal, 4)
                            
                            if evaluated.qualified.isEmpty {
                                Text("No matching courses found for your current marks.")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                    .padding(.horizontal, 4)
                            } else {
                                ForEach(evaluated.qualified) { course in
                                    CourseMatchRow(course: course, isQualified: true)
                                }
                            }
                        }
                        
                        // Unqualified Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "xmark.seal.fill")
                                    .foregroundStyle(.red)
                                Text("Unqualified Courses (\(evaluated.unqualified.count))")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal, 4)
                            
                            if evaluated.unqualified.isEmpty {
                                Text("No unqualified courses in this view.")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                    .padding(.horizontal, 4)
                            } else {
                                ForEach(evaluated.unqualified) { course in
                                    CourseMatchRow(course: course, isQualified: false)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    // MARK: - Match Engine Logic Helpers
    
    private var currentSelectedUniversity: UniversityModel? {
        allUniversities.first(where: { $0.university == selectedUniversityName })
    }
    
    private var availableFacultiesForSelectedUni: [String] {
        guard let uni = currentSelectedUniversity else { return [] }
        return Array(Set(uni.faculties.map { $0.faculty })).sorted()
    }
    
    private func evaluatedCoursesForSelectedUniversity() -> (qualified: [EvaluatedCourse], unqualified: [EvaluatedCourse]) {
        guard let uni = currentSelectedUniversity else { return ([], []) }
        
        let singleUniResponse = UniversityDataResponse(universities: [uni])
        let mathsLevel = subjects.first(where: { $0.name.contains("Math") })?.apsLevel ?? 0
        let englishLevel = subjects.first(where: { $0.name.contains("English") })?.apsLevel ?? 0
        
        let (qualified, unqualified) = CourseEvaluator.evaluateCourses(
            from: singleUniResponse,
            studentAPS: calculateAPS(),
            studentMathsLevel: mathsLevel,
            studentEnglishLevel: englishLevel
        )
        
        if selectedFacultyName == "All Faculties" {
            return (qualified, unqualified)
        } else {
            let filteredQualified = qualified.filter { $0.facultyName == selectedFacultyName }
            let filteredUnqualified = unqualified.filter { $0.facultyName == selectedFacultyName }
            return (filteredQualified, filteredUnqualified)
        }
    }
    
    private func loadUniversityDataset() {
        guard let url = Bundle.main.url(forResource: "south-africa-public-university-courses-2026", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            isLoadingData = false
            return
        }
        
        if let decoded = try? JSONDecoder().decode(UniversityDataResponse.self, from: data) {
            self.allUniversities = decoded.universities
            if let firstUni = decoded.universities.first {
                self.selectedUniversityName = firstUni.university
            }
        }
        self.isLoadingData = false
    }
    
    // MARK: - APS Calculation & Persistence
    
    func calculateAPS() -> Int {
        let validSubjects = subjects.filter { $0.name != "Life Orientation" }
        let sortedLevels = validSubjects.map { $0.apsLevel }.sorted(by: >)
        let topSix = sortedLevels.prefix(6)
        return topSix.reduce(0, +)
    }
    
    func saveSubjects() {
        if let encoded = try? JSONEncoder().encode(subjects) {
            savedSubjectsData = encoded
        }
    }
    
    func loadSubjects() {
        if let decoded = try? JSONDecoder().decode([SubjectScore].self, from: savedSubjectsData) {
            subjects = decoded
        }
    }
    
    func deleteSubject(at offsets: IndexSet) {
        subjects.remove(atOffsets: offsets)
        saveSubjects()
    }
}

// MARK: - Course Match Display Card Component

struct CourseMatchRow: View {
    let course: EvaluatedCourse
    let isQualified: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(course.course.course)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text(isQualified ? "Eligible" : "Not Eligible")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(isQualified ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .foregroundStyle(isQualified ? Color.green : Color.red)
                    .cornerRadius(6)
            }
            
            Text("Faculty: \(course.facultyName)")
                .font(.caption)
                .foregroundStyle(.gray)
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            VStack(alignment: .leading, spacing: 4) {
                if course.course.minimumRequirements.admissionScore != "n/a" {
                    Text("Admission Score: \(course.course.minimumRequirements.admissionScore)")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
                
                if course.course.minimumRequirements.subjectRequirements != "n/a" {
                    Text("Subjects: \(course.course.minimumRequirements.subjectRequirements)")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
                
                Text(course.reason)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(isQualified ? .green : .red)
                    .padding(.top, 2)
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Modal View for Adding Subjects

struct AddSubjectView: View {
    @Environment(\.dismiss) var dismiss
    let availableSubjects: [String]
    let existingSubjects: [SubjectScore]
    var onAdd: (SubjectScore) -> Void
    
    @State private var selectedSubject = "Mathematics"
    @State private var markString = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Subject", selection: $selectedSubject) {
                    ForEach(availableSubjects, id: \.self) { subject in
                        Text(subject).tag(subject)
                    }
                }
                
                Section("Enter Final Mark / Term Mark") {
                    TextField("Percentage (e.g. 75)", text: $markString)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add Subject")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if let mark = Int(markString) {
                            let newItem = SubjectScore(name: selectedSubject, mark: mark)
                            onAdd(newItem)
                            dismiss()
                        }
                    }
                    .disabled(markString.isEmpty)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    APS_Tracker()
}
