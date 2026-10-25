//
//  Calendar & Deadlines Page.swift
//  Veyora
//
//  Created by Lesego Mashego on 2026/10/16.
//

import SwiftUI
import UserNotifications

// MARK: - Dedicated Local Data Model

struct SAUniversityDeadline: Identifiable {
    let id = UUID()
    let name: String
    let abbreviation: String
    let openDate: Date
    let closeDate: Date
    let earlyCloseDate: Date?
    let earlyCloseProgram: String?
    let officialLink: String
    let applicationFee: String
    let description: String
    
    var isOpen: Bool {
        let now = Date()
        return now >= openDate && now <= closeDate
    }
    
    var daysRemaining: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: closeDate)
        return max(0, components.day ?? 0)
    }
}

// MARK: - Main Calendar / Deadlines Page

struct Calendar___Deadlines_Page: View {
    
    private static func createDate(year: Int = 2026, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }
    
    let universities: [SAUniversityDeadline] = [
        SAUniversityDeadline(
            name: "University of Pretoria (UP)", abbreviation: "UP",
            openDate: createDate(month: 4, day: 1), closeDate: createDate(month: 6, day: 30),
            earlyCloseDate: createDate(month: 5, day: 31), earlyCloseProgram: "Veterinary Science (BSc VetNurs / BVSc)",
            officialLink: "https://www.up.ac.za/online-application", applicationFee: "R300 (Non-refundable)",
            description: "Located in Tshwane, UP is a premier research university. High competition for Health Sciences, Engineering, and Law. NBTs are required for specific faculties. Residence applications close concurrently with academic applications."
        ),
        SAUniversityDeadline(
            name: "Sefako Makgatho Health Sciences University (SMU)", abbreviation: "SMU",
            openDate: createDate(month: 4, day: 1), closeDate: createDate(month: 7, day: 31),
            earlyCloseDate: nil, earlyCloseProgram: nil,
            officialLink: "https://www.smu.ac.za/apply-now/", applicationFee: "R200",
            description: "Dedicated exclusively to health and medical sciences in Ga-Rankuwa, Gauteng. Requires strong performance in Life Sciences, Physical Sciences, and Mathematics."
        ),
        SAUniversityDeadline(
            name: "Tshwane University of Technology (TUT)", abbreviation: "TUT",
            openDate: createDate(month: 4, day: 1), closeDate: createDate(month: 7, day: 31),
            earlyCloseDate: createDate(month: 6, day: 15), earlyCloseProgram: "Selected specialisation qualifications; international applicants",
            officialLink: "https://www.tut.ac.za/apply-now", applicationFee: "R240 (Free online for SA citizens)",
            description: "South Africa's largest university of technology. Offers career-oriented diplomas and degrees across multiple campuses in Gauteng, Mpumalanga, and Limpopo."
        ),
        SAUniversityDeadline(
            name: "University of Cape Town (UCT)", abbreviation: "UCT",
            openDate: createDate(month: 4, day: 1), closeDate: createDate(month: 7, day: 31),
            earlyCloseDate: nil, earlyCloseProgram: nil,
            officialLink: "https://applyonline.uct.ac.za", applicationFee: "R100 for SA/SADC (Waived for low-income applicants)",
            description: "South Africa's top-ranked university. Operates on a Faculty Points Score (FPS) system out of 600 or 800 points. NBT scores are mandatory for Health Sciences and recommended across other faculties."
        ),
        SAUniversityDeadline(
            name: "Stellenbosch University (SU)", abbreviation: "SU",
            openDate: createDate(month: 4, day: 1), closeDate: createDate(month: 7, day: 31),
            earlyCloseDate: nil, earlyCloseProgram: nil,
            officialLink: "https://www.sun.ac.za/apply", applicationFee: "R100 (Waived for Quintile 1-3 school applicants)",
            description: "Evaluates applicants on the Tuned Points Total (TPT) percentage average rather than point bands. Highly competitive for Medicine (Tygerberg campus), Law, and Engineering."
        ),
        SAUniversityDeadline(
            name: "North-West University (NWU)", abbreviation: "NWU",
            openDate: createDate(month: 6, day: 1), closeDate: createDate(month: 8, day: 31),
            earlyCloseDate: createDate(month: 6, day: 30), earlyCloseProgram: "Selection courses (Pharmacy, Nursing, Music)",
            officialLink: "https://studies.nwu.ac.za/undergraduate-studies", applicationFee: "R0 (Free Online Application)",
            description: "Multi-campus institution with locations in Potchefstroom, Mahikeng, and Vanderbijlpark. Uses an extended 8-point APS scale that recognizes performance above 90%."
        ),
        SAUniversityDeadline(
            name: "Durban University of Technology (DUT)", abbreviation: "DUT",
            openDate: createDate(month: 3, day: 1), closeDate: createDate(month: 9, day: 30),
            earlyCloseDate: nil, earlyCloseProgram: "Some health-science programmes; dates vary",
            officialLink: "https://www.cao.ac.za", applicationFee: "R250 via CAO (Central Applications Office)",
            description: "Applications for first-time entry must be submitted through the Central Applications Office (CAO) in KwaZulu-Natal."
        ),
        SAUniversityDeadline(
            name: "Mangosuthu University of Technology (MUT)", abbreviation: "MUT",
            openDate: createDate(month: 3, day: 1), closeDate: createDate(month: 9, day: 30),
            earlyCloseDate: nil, earlyCloseProgram: nil,
            officialLink: "https://www.cao.ac.za", applicationFee: "R250 via CAO",
            description: "Located in Umlazi, Durban. Focuses on technological, engineering, and management fields. Applications are routed through KZN CAO."
        ),
        SAUniversityDeadline(
            name: "Nelson Mandela University (NMU)", abbreviation: "NMU",
            openDate: createDate(month: 4, day: 1), closeDate: createDate(month: 9, day: 30),
            earlyCloseDate: createDate(month: 6, day: 30), earlyCloseProgram: "Medicine, Nursing, Pharmacy, Diagnostic Radiography",
            officialLink: "https://applyonline.mandela.ac.za", applicationFee: "R0 (Free Online Application for SA Citizens)",
            description: "Based in Gqeberha (Port Elizabeth). Evaluates applicants using the Applicant Score (AS) out of 600, with a flat +7 equity bonus for Quintile 1-3 school learners."
        ),
        SAUniversityDeadline(
            name: "Rhodes University", abbreviation: "Rhodes",
            openDate: createDate(month: 4, day: 1), closeDate: createDate(month: 9, day: 30),
            earlyCloseDate: nil, earlyCloseProgram: nil,
            officialLink: "https://ross.ru.ac.za", applicationFee: "R100",
            description: "Situated in Makhanda (Grahamstown). Renowned for Humanities, Journalism, Pharmacy, and Science programmes with vibrant residential campus life."
        ),
        SAUniversityDeadline(
            name: "Sol Plaatje University (SPU)", abbreviation: "SPU",
            openDate: createDate(month: 4, day: 1), closeDate: createDate(month: 9, day: 30),
            earlyCloseDate: nil, earlyCloseProgram: nil,
            officialLink: "https://www.spu.ac.za/index.php/how-to-apply/", applicationFee: "R0 (Free Online Application)",
            description: "Located in Kimberley, Northern Cape. Specializes in Education, Data Science, Humanities, and Heritage Studies."
        ),
        SAUniversityDeadline(
            name: "Central University of Technology (CUT)", abbreviation: "CUT",
            openDate: createDate(month: 4, day: 1), closeDate: createDate(month: 9, day: 30),
            earlyCloseDate: nil, earlyCloseProgram: nil,
            officialLink: "https://www.cut.ac.za/apply", applicationFee: "R0 (Free Online Application)",
            description: "Main campuses in Bloemfontein and Welkom. Offers specialized career training in Engineering, Health Technology, and Management Sciences."
        ),
        SAUniversityDeadline(
            name: "University of the Western Cape (UWC)", abbreviation: "UWC",
            openDate: createDate(month: 4, day: 1), closeDate: createDate(month: 9, day: 30),
            earlyCloseDate: nil, earlyCloseProgram: nil,
            officialLink: "https://student.uwc.ac.za", applicationFee: "R0 (Free Online Application for SA Citizens)",
            description: "Located in Bellville, Cape Town. Features a custom 8-point weighted APS scale double-weighting English and Mathematics."
        ),
        SAUniversityDeadline(
            name: "University of the Free State (UFS)", abbreviation: "UFS",
            openDate: createDate(month: 4, day: 1), closeDate: createDate(month: 9, day: 30),
            earlyCloseDate: createDate(month: 5, day: 31), earlyCloseProgram: "Medicine, Occupational Therapy, Optometry, Physiotherapy, Dietetics",
            officialLink: "https://apply.ufs.ac.za", applicationFee: "R0 (Free Online Application for SA Citizens)",
            description: "Campuses in Bloemfontein (Main & South) and Qwaqwa. Offers strong programmes in Health Sciences, Agriculture, Law, and Humanities."
        ),
        SAUniversityDeadline(
            name: "University of KwaZulu-Natal (UKZN)", abbreviation: "UKZN",
            openDate: createDate(month: 3, day: 1), closeDate: createDate(month: 9, day: 30),
            earlyCloseDate: createDate(month: 6, day: 30), earlyCloseProgram: "Medicine (MBChB)",
            officialLink: "https://www.cao.ac.za", applicationFee: "R250 via CAO",
            description: "Five campuses across Durban and Pietermaritzburg. All undergraduate applications are submitted via CAO."
        ),
        SAUniversityDeadline(
            name: "University of Limpopo (UL)", abbreviation: "UL",
            openDate: createDate(month: 5, day: 1), closeDate: createDate(month: 9, day: 30),
            earlyCloseDate: createDate(month: 7, day: 30), earlyCloseProgram: "Medicine (MBChB); international applicants",
            officialLink: "https://www.ul.ac.za/index.php?Entity=apply", applicationFee: "R200 (SA Citizens)",
            description: "Located at Turfloop, Limpopo. Strong academic focus on Health Sciences, Agriculture, Science, and Law."
        ),
        SAUniversityDeadline(
            name: "University of Venda (UNIVEN)", abbreviation: "UNIVEN",
            openDate: createDate(month: 5, day: 1), closeDate: createDate(month: 9, day: 30),
            earlyCloseDate: nil, earlyCloseProgram: nil,
            officialLink: "https://www.univen.ac.za/students/how-to-apply/", applicationFee: "R100",
            description: "Situated in Thohoyandou, Limpopo. Offers comprehensive programmes in Health Sciences, Agriculture, Environmental Sciences, and Management."
        ),
        SAUniversityDeadline(
            name: "University of Zululand (UNIZULU)", abbreviation: "UNIZULU",
            openDate: createDate(month: 3, day: 1), closeDate: createDate(month: 9, day: 30),
            earlyCloseDate: nil, earlyCloseProgram: nil,
            officialLink: "https://www.cao.ac.za", applicationFee: "R250 via CAO",
            description: "Main campus at KwaDlangezwa and Richards Bay campus. Applications must be routed through KZN CAO."
        ),
        SAUniversityDeadline(
            name: "Cape Peninsula University of Technology (CPUT)", abbreviation: "CPUT",
            openDate: createDate(month: 5, day: 11), closeDate: createDate(month: 9, day: 30),
            earlyCloseDate: createDate(month: 6, day: 30), earlyCloseProgram: "Dental Assisting, Nursing (Extended), Diagnostic Imaging",
            officialLink: "https://www.cput.ac.za/study/apply", applicationFee: "R0 (Free Online Application)",
            description: "The largest university of technology in the Western Cape with campuses in Bellville, District Six, Granger Bay, Mowbray, and Wellington."
        ),
        SAUniversityDeadline(
            name: "Vaal University of Technology (VUT)", abbreviation: "VUT",
            openDate: createDate(month: 6, day: 1), closeDate: createDate(month: 9, day: 30),
            earlyCloseDate: nil, earlyCloseProgram: nil,
            officialLink: "https://www.vut.ac.za/apply-to-vut/", applicationFee: "R110",
            description: "Main campus in Vanderbijlpark, Gauteng. Specializes in Engineering, Applied Sciences, Management, and Human Sciences."
        ),
        SAUniversityDeadline(
            name: "University of the Witwatersrand (Wits)", abbreviation: "Wits",
            openDate: createDate(month: 3, day: 1), closeDate: createDate(month: 9, day: 30),
            earlyCloseDate: createDate(month: 5, day: 31), earlyCloseProgram: "Faculty of Health Sciences & Selection Degrees",
            officialLink: "https://www.wits.ac.za/undergraduate/apply-to-wits/", applicationFee: "R100 for SA Citizens",
            description: "Located in Braamfontein, Johannesburg. Uses a custom 7-subject score scale (capped at 60) featuring +2 subject bonuses for Mathematics and English ≥ 60%."
        ),
        SAUniversityDeadline(
            name: "University of South Africa (UNISA)", abbreviation: "UNISA",
            openDate: createDate(month: 8, day: 1), closeDate: createDate(month: 10, day: 9),
            earlyCloseDate: nil, earlyCloseProgram: "Qualification-specific diploma and degree intakes",
            officialLink: "https://www.unisa.ac.za/sites/corporate/default/Apply-for-admission", applicationFee: "R135 (Online Application)",
            description: "Africa's largest open distance learning institution. Enables flexible remote higher education across all nine South African provinces."
        ),
        SAUniversityDeadline(
            name: "University of Johannesburg (UJ)", abbreviation: "UJ",
            openDate: createDate(month: 4, day: 1), closeDate: createDate(month: 10, day: 31),
            earlyCloseDate: nil, earlyCloseProgram: nil,
            officialLink: "https://www.uj.ac.za/admission-aid/undergraduate/", applicationFee: "R0 (Free Online Application)",
            description: "Four campuses across Johannesburg (APK, APB, DFC, SWC). Features the Orange Carpet automatic merit scholarship for high APS achievers."
        ),
        SAUniversityDeadline(
            name: "University of Fort Hare (UFH)", abbreviation: "UFH",
            openDate: createDate(month: 6, day: 1), closeDate: createDate(month: 10, day: 31),
            earlyCloseDate: nil, earlyCloseProgram: nil,
            officialLink: "https://www.ufh.ac.za/apply/", applicationFee: "R120",
            description: "Campuses in Alice, East London, and Bhisho. Historic university with strong Law, Agriculture, Science, and Business faculties."
        ),
        SAUniversityDeadline(
            name: "Walter Sisulu University (WSU)", abbreviation: "WSU",
            openDate: createDate(month: 6, day: 1), closeDate: createDate(month: 10, day: 31),
            earlyCloseDate: nil, earlyCloseProgram: nil,
            officialLink: "https://www.wsu.ac.za/index.php/study-with-us/apply-to-wsu", applicationFee: "R0 (Free Online Application)",
            description: "Spans campuses in Mthatha, East London, Butterworth, and Komani. Focuses on Medicine, Health Sciences, Education, and Technology."
        ),
        SAUniversityDeadline(
            name: "University of Mpumalanga (UMP)", abbreviation: "UMP",
            openDate: createDate(month: 6, day: 1), closeDate: createDate(month: 11, day: 30),
            earlyCloseDate: nil, earlyCloseProgram: nil,
            officialLink: "https://www.ump.ac.za/Study-with-us/Apply", applicationFee: "R0 (Free Online Application)",
            description: "Campuses in Mbombela and Siyabuswa. Focuses on Agriculture, Hospitality, Development Studies, and Education."
        )
    ]
    
    var sortedUniversities: [SAUniversityDeadline] {
        universities.sorted { lhs, rhs in
            if lhs.isOpen == rhs.isOpen {
                return lhs.closeDate < rhs.closeDate
            }
            return lhs.isOpen && !rhs.isOpen
        }
    }
    
    @State private var selectedUniversity: SAUniversityDeadline? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(sortedUniversities) { uni in
                            Button(action: {
                                selectedUniversity = uni
                            }) {
                                HStack(alignment: .center) {
                                    if uni.isOpen {
                                        VStack(alignment: .center, spacing: 2) {
                                            Text("\(uni.daysRemaining)")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundStyle(.blue)
                                            Text("days left")
                                                .font(.caption2)
                                                .foregroundStyle(.gray)
                                        }
                                        .frame(width: 65)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(uni.name)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                            .multilineTextAlignment(.leading)
                                        
                                        HStack(spacing: 6) {
                                            Circle()
                                                .fill(uni.isOpen ? Color.green : Color.red)
                                                .frame(width: 8, height: 8)
                                            
                                            Text(uni.isOpen ? "Open" : "Closed")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(uni.isOpen ? .green : .red)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.ultraThinMaterial)
                                .cornerRadius(14)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                    .padding(.bottom, 80)
                }
            }
            .navigationTitle("University Deadlines")
            .preferredColorScheme(.dark)
            .sheet(item: $selectedUniversity) { uni in
                SAUniversityDetailView(university: uni)
            }
        }
    }
}

// MARK: - Dedicated Local University Detail Sheet View

struct SAUniversityDetailView: View {
    let university: SAUniversityDeadline
    @Environment(\.dismiss) var dismiss
    @AppStorage("reminderLeadDays") private var reminderLeadDays: Int = 7
    
    @State private var isReminderSet = false
    @State private var showReminderAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        // Header Section
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(university.abbreviation)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundStyle(.blue)
                                    .cornerRadius(8)
                                
                                Spacer()
                                
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(university.isOpen ? Color.green : Color.red)
                                        .frame(width: 8, height: 8)
                                    Text(university.isOpen ? "Applications Open" : "Applications Closed")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundStyle(university.isOpen ? Color.green : Color.red)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(university.isOpen ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                                .cornerRadius(8)
                            }
                            
                            Text(university.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        // Deadline Reminder Action Button
                        Button(action: scheduleUniversityReminder) {
                            HStack {
                                Image(systemName: isReminderSet ? "bell.fill" : "bell.badge")
                                Text(isReminderSet ? "Reminder Set (\(reminderLeadDays) Days Before)" : "Set Deadline Reminder (\(reminderLeadDays) Days Before)")
                                    .fontWeight(.semibold)
                            }
                            .font(.subheadline)
                            .foregroundStyle(isReminderSet ? .green : .blue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(isReminderSet ? Color.green.opacity(0.15) : Color.blue.opacity(0.15))
                            .cornerRadius(12)
                        }
                        
                        // Key Details Grid
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("APPLICATION FEE")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.gray)
                                    Text(university.applicationFee)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.green)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(12)
                            
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("OPEN DATE")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.gray)
                                    Text(formattedDate(university.openDate))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.06))
                                .cornerRadius(12)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("CLOSING DATE")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.gray)
                                    Text(formattedDate(university.closeDate))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.orange)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.06))
                                .cornerRadius(12)
                            }
                        }
                        
                        // Early Closing Alert if applicable
                        if let earlyDate = university.earlyCloseDate, let program = university.earlyCloseProgram {
                            VStack(alignment: .leading, spacing: 6) {
                                Label("Early Closing Programs", systemImage: "exclamationmark.triangle.fill")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.orange)
                                
                                Text("Closing Date: \(formattedDate(earlyDate))")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                
                                Text(program)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.orange.opacity(0.12))
                            .cornerRadius(12)
                        }
                        
                        // About & Requirements
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About & Application Guidelines")
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            Text(university.description)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .lineSpacing(4)
                        }
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
                
                // Bottom Fixed Action Button (Long Pill / Ellipse)
                VStack {
                    if let url = URL(string: university.officialLink) {
                        Link(destination: url) {
                            HStack(spacing: 8) {
                                Text("Apply to \(university.abbreviation) Now")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Image(systemName: "arrow.up.right.circle.fill")
                                    .font(.title3)
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [Color.blue, Color.blue.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: Color.blue.opacity(0.4), radius: 10, x: 0, y: 5)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                .background(
                    LinearGradient(
                        colors: [Color.black.opacity(0.95), Color.black.opacity(0.0)],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .ignoresSafeArea()
                )
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("University Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .alert("Deadline Reminder", isPresented: $showReminderAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func scheduleUniversityReminder() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "\(university.abbreviation) Deadline Approaching! 🚨"
                content.body = "\(university.name) applications close in \(reminderLeadDays) days on \(formattedDate(university.closeDate)). Open Veroya to apply now!"
                content.sound = .default
                
                let reminderDate = Calendar.current.date(byAdding: .day, value: -reminderLeadDays, to: university.closeDate) ?? university.closeDate
                let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
                let request = UNNotificationRequest(identifier: university.id.uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    DispatchQueue.main.async {
                        if error == nil {
                            isReminderSet = true
                            alertMessage = "Reminder set! We'll notify you \(reminderLeadDays) days before \(university.abbreviation) applications close."
                            showReminderAlert = true
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    alertMessage = "Please enable notifications in your iPhone Settings to set deadline reminders."
                    showReminderAlert = true
                }
            }
        }
    }
}

#Preview {
    Calendar___Deadlines_Page()
}

