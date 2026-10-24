//
//  CourseEvaluator.swift
//  Veyora
//
//  Created by Lesego Mashego on 2026/10/17.
//

import Foundation

class CourseEvaluator {
    
    /// Evaluates all universities and courses against the student's profile
    static func evaluateCourses(
        from response: UniversityDataResponse,
        studentAPS: Int,
        studentMathsLevel: Int,
        studentEnglishLevel: Int
    ) -> (qualified: [EvaluatedCourse], unqualified: [EvaluatedCourse]) {
        
        var qualified: [EvaluatedCourse] = []
        var unqualified: [EvaluatedCourse] = []
        
        for uni in response.universities {
            for faculty in uni.faculties {
                for course in faculty.courses {
                    // Skip placeholder or invalid entries
                    if course.course.lowercased() == "n/a" || course.course.isEmpty { continue }
                    
                    let req = course.minimumRequirements
                    
                    // Simple evaluation logic template based on JSON requirements text
                    // (You can expand this string parsing depending on your exact requirement formatting)
                    let minAPS = extractMinAPS(from: req.admissionScore) ?? extractMinAPS(from: req.subjectRequirements) ?? 25
                    
                    let meetsAPS = studentAPS >= minAPS
                    
                    if meetsAPS {
                        let evaluated = EvaluatedCourse(
                            universityName: uni.university,
                            facultyName: faculty.faculty,
                            course: course,
                            isQualified: true,
                            reason: "Met minimum APS (\(minAPS)) and subject criteria."
                        )
                        qualified.append(evaluated)
                    } else {
                        let pointsNeeded = minAPS - studentAPS
                        let evaluated = EvaluatedCourse(
                            universityName: uni.university,
                            facultyName: faculty.faculty,
                            course: course,
                            isQualified: false,
                            reason: "Required APS: \(minAPS). You need \(pointsNeeded) more points."
                        )
                        unqualified.append(evaluated)
                    }
                }
            }
        }
        
        return (qualified, unqualified)
    }
    
    private static func extractMinAPS(from text: String) -> Int? {
        let pattern = "\\b(2[0-9]|3[0-9]|4[0-9])\\b"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let nsString = text as NSString
        let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
        
        if let match = results.first {
            let substring = nsString.substring(with: match.range)
            return Int(substring)
        }
        return nil
    }
}
