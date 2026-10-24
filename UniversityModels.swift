//
//  UniversityModels.swift
//  Veyora
//
//  Created by Lesego Mashego on 2026/10/17.
//

import Foundation

// MARK: - Root Response
struct UniversityDataResponse: Codable {
    let universities: [UniversityModel]
}

// MARK: - University
struct UniversityModel: Codable, Identifiable {
    var id: String { university }
    let university: String
    let faculties: [FacultyModel]
}

// MARK: - Faculty
struct FacultyModel: Codable, Identifiable {
    var id: String { faculty }
    let faculty: String
    let courses: [CourseModel]
}

// MARK: - Course
struct CourseModel: Codable, Identifiable {
    var id: String { course }
    let course: String
    let minimumRequirements: MinimumRequirementsModel
}

// MARK: - Minimum Requirements
struct MinimumRequirementsModel: Codable {
    let admissionScore: String
    let subjectRequirements: String
    let otherRequirements: String
}

// MARK: - Evaluated Course Wrapper for UI
struct EvaluatedCourse: Identifiable {
    let id = UUID()
    let universityName: String
    let facultyName: String
    let course: CourseModel
    let isQualified: Bool
    let reason: String
}
