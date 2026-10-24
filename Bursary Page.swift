//
//  Bursary Page.swift
//  Veyora
//
//  Created by Lesego Mashego on 2026/10/16.
//

import SwiftUI

// MARK: - Data Models

enum ApplicationType: String {
    case automatic = "Automatic"
    case manual = "Manual Application"
    case mixed = "Automatic & Manual"
    
    var color: Color {
        switch self {
        case .automatic: return .green
        case .manual: return .orange
        case .mixed: return .blue
        }
    }
}

struct BursaryAward: Identifiable {
    let id = UUID()
    let name: String
    let amountOrCoverage: String
    let requirement: String
}

struct UniversityBursary: Identifiable {
    let id = UUID()
    let universityName: String
    let abbreviation: String
    let applicationType: ApplicationType
    let summary: String
    let awards: [BursaryAward]
    let notes: String
}

// MARK: - Private Bursary Data Model

struct PrivateBursaryItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let isOpen: Bool
    let applicationDates: String
    let compensation: String
    let eligibility: String
    let applicationURL: URL?
}

// MARK: - Main Bursary Page View

struct Bursary_Page: View {
    @State private var selectedTab: Int = 0 // 0 = University, 1 = Private
    @State private var selectedBursary: UniversityBursary? = nil
    
    // Private Tab Filtering & Search State
    @State private var searchText = ""
    @State private var filterSelection: PrivateFilterOption = .all
    
    enum PrivateFilterOption: String, CaseIterable, Identifiable {
        case all = "All"
        case open = "Open"
        case closed = "Closed"
        var id: String { self.rawValue }
    }
    
    // Comprehensive University Bursaries Dataset
    let universityBursaries: [UniversityBursary] = [
        UniversityBursary(
            universityName: "University of Cape Town (UCT)",
            abbreviation: "UCT",
            applicationType: .mixed,
            summary: "Entrance scholarships are automatic with no application required for SA citizens/PR. Guaranteed to applicants who meet published faculty thresholds.",
            awards: [
                BursaryAward(name: "Vice-Chancellor's Scholarship", amountOrCoverage: "R100 000 / year", requirement: "For top Olympiad winners & top NSC applicants (e.g. top 10 Western Cape schools). Up to 3 years."),
                BursaryAward(name: "Commerce Faculty Award", amountOrCoverage: "R40 000", requirement: "FPS 540-560 + Proficient NBT. Redress applicants qualify from FPS 500."),
                BursaryAward(name: "Engineering & Built Env.", amountOrCoverage: "R60 000 each", requirement: "Based on FPS. 60% allocated towards gender diversity."),
                BursaryAward(name: "Humanities (BA/BSocSc)", amountOrCoverage: "R40 000", requirement: "FPS 525 (87.5% avg) + NBT Proficient. Redress from FPS 495 (82.5%)."),
                BursaryAward(name: "Law (LLB)", amountOrCoverage: "R20 000", requirement: "FPS 510 + 80% NBT avg. Redress applicants need FPS 500 + 75% NBT."),
                BursaryAward(name: "Science", amountOrCoverage: "R20 000 - R40 000", requirement: "R40k for FPS 740+; R20k for FPS 720-739. Requires Math >= 85%."),
                BursaryAward(name: "Mastercard Foundation", amountOrCoverage: "Full Funding", requirement: "Separate manual application (Closed for 2027).")
            ],
            notes: "Offers go out after final NSC results in January 2027."
        ),
        UniversityBursary(
            universityName: "University of the Witwatersrand (Wits)",
            abbreviation: "Wits",
            applicationType: .mixed,
            summary: "Entrance scholarships are automatically calculated on NSC APS score (excluding Life Orientation). Covers tuition fees only.",
            awards: [
                BursaryAward(name: "Entrance Merit (APS 51+)", amountOrCoverage: "100% Tuition", requirement: "APS 51 or higher."),
                BursaryAward(name: "Entrance Merit (APS 48-50)", amountOrCoverage: "R45 000", requirement: "APS 48 to 50."),
                BursaryAward(name: "Entrance Merit (APS 45-47)", amountOrCoverage: "R25 000", requirement: "APS 45 to 47."),
                BursaryAward(name: "Entrance Merit (APS 43-44)", amountOrCoverage: "R20 000", requirement: "APS 43 to 44."),
                BursaryAward(name: "Vice-Chancellor's Award", amountOrCoverage: "Full Tuition + Acc. Capped", requirement: "Automatic for top 20 first-time entrants."),
                BursaryAward(name: "Olympiad Winners", amountOrCoverage: "R10 000 - R50 000", requirement: "R50k overall winner; R10k top 5 runners-up. Must submit certificate."),
                BursaryAward(name: "Sports Bursaries", amountOrCoverage: "Varies", requirement: "Manual application (Closed 30 Sept).")
            ],
            notes: "Matric remarks must be submitted by 30 September. NSFAS recipients do not receive Wits Council scholarships. Funding cap: R205 000."
        ),
        UniversityBursary(
            universityName: "Stellenbosch University (SU)",
            abbreviation: "SU",
            applicationType: .automatic,
            summary: "All main merit awards are automatic with no application process. Open to SA citizens & permanent residents.",
            awards: [
                BursaryAward(name: "Vice-Chancellor Award", amountOrCoverage: "R100 000", requirement: "15 awards allocated nationally."),
                BursaryAward(name: "Achiever Award", amountOrCoverage: "R75 000", requirement: "20 awards (top 10 overall + top 10 from quintile 1-4 schools)."),
                BursaryAward(name: "Excel Award", amountOrCoverage: "R25 000", requirement: "Top 1-5% of first-year students in each faculty."),
                BursaryAward(name: "Access Award", amountOrCoverage: "R5 000 - R10 000", requirement: "Quintile 1-4 school students with 80%+ matric avg (R5k for 80-85%, R7.5k for 85-90%, R10k for 90%+).")
            ],
            notes: "Payments reflect on student accounts by the June statement at latest. Need-based funding requires annual application through SUFO."
        ),
        UniversityBursary(
            universityName: "University of Pretoria (Fly@UP Assist)",
            abbreviation: "UP",
            applicationType: .mixed,
            summary: "Fly@UP Assist merit awards are automatic based on top 6 subjects (excluding Life Orientation).",
            awards: [
                BursaryAward(name: "Award A (Merit)", amountOrCoverage: "R18 000 / R45 000", requirement: "R18k for 80-89.99% avg; R45k for 90%+ avg."),
                BursaryAward(name: "Award B (Math & Science)", amountOrCoverage: "R2 000 per subject", requirement: "Scoring 80%+ in Math or Physical Sciences (Maths Lit excluded)."),
                BursaryAward(name: "VC Distinguished Merit", amountOrCoverage: "Full 3-year Tuition", requirement: "R150 000 in first year."),
                BursaryAward(name: "Cambridge & IB", amountOrCoverage: "R5 000 per symbol", requirement: "Up to maximum R30 000."),
                BursaryAward(name: "TuksSport Bursary", amountOrCoverage: "Varies", requirement: "Manual application (Closed 31 July 2026).")
            ],
            notes: "Extra results or gap-year affidavits must be uploaded to the portal by end of February or award is forfeited."
        ),
        UniversityBursary(
            universityName: "University of Johannesburg (Orange Carpet)",
            abbreviation: "UJ",
            applicationType: .automatic,
            summary: "Automatic entry award for first-time SA/SADC students who have never studied elsewhere.",
            awards: [
                BursaryAward(name: "APS 37 - 39", amountOrCoverage: "50% Tuition", requirement: "Total APS 37 to 39."),
                BursaryAward(name: "APS 40 - 41", amountOrCoverage: "75% Tuition", requirement: "Total APS 40 to 41."),
                BursaryAward(name: "APS 42", amountOrCoverage: "100% Tuition", requirement: "Total APS 42."),
                BursaryAward(name: "APS 42+", amountOrCoverage: "100% Tuition + R5 485", requirement: "APS > 42 with 80%+ in top 6 subjects and 90%+ in at least one.")
            ],
            notes: "Allocated between April and August of 1st year. Residence guaranteed if applied before 30 June."
        ),
        UniversityBursary(
            universityName: "University of KwaZulu-Natal (UKZN)",
            abbreviation: "UKZN",
            applicationType: .mixed,
            summary: "Prestige and Entrant merit awards are automatic via CAO application.",
            awards: [
                BursaryAward(name: "Pius Langa Prestige", amountOrCoverage: "R50 000", requirement: "Top 10 matriculants in each province or top 50 IEB matriculants nationally in KZN."),
                BursaryAward(name: "Entrant Merit (6 Subjects)", amountOrCoverage: "R25 000", requirement: "Level 7 (80%+) in at least 6 subjects (excl. LO & Maths Lit)."),
                BursaryAward(name: "Entrant Merit (5 Subjects)", amountOrCoverage: "R20 000", requirement: "Level 7 (80%+) in at least 5 subjects."),
                BursaryAward(name: "Frene Ginwala", amountOrCoverage: "R20 000", requirement: "Top 10 African female entrants."),
                BursaryAward(name: "Prestige Sports", amountOrCoverage: "Varies", requirement: "Manual application (Closing 31 October).")
            ],
            notes: "Entrant merit awards continue at R25 000 in subsequent years if an 80%+ weighted avg is maintained."
        ),
        UniversityBursary(
            universityName: "North-West University (NWU)",
            abbreviation: "NWU",
            applicationType: .mixed,
            summary: "First-year merit awards are automatic (excluding Life Orientation).",
            awards: [
                BursaryAward(name: "85% - 100% Average", amountOrCoverage: "100% Tuition", requirement: "Matric avg 85% or higher."),
                BursaryAward(name: "80% - 84% Average", amountOrCoverage: "75% Tuition", requirement: "Matric avg 80% to 84%."),
                BursaryAward(name: "75% - 79% Average", amountOrCoverage: "25% Tuition", requirement: "Matric avg 75% to 79%."),
                BursaryAward(name: "Leadership Bursary", amountOrCoverage: "R3 500", requirement: "Manual application for Head Boy/Girl (Closes 28 Feb).")
            ],
            notes: "Students fully covered by NSFAS cannot receive NWU merit bursaries."
        ),
        UniversityBursary(
            universityName: "Nelson Mandela University (NMU)",
            abbreviation: "NMU",
            applicationType: .mixed,
            summary: "Scholar Merit Award is automatic, calculated from applicant score (sum of top 6 subject percentages out of 600).",
            awards: [
                BursaryAward(name: "Score 500+", amountOrCoverage: "R16 500", requirement: "Applicant score 500 or higher."),
                BursaryAward(name: "Score 470 - 499", amountOrCoverage: "R12 500", requirement: "Applicant score 470 to 499."),
                BursaryAward(name: "Score 410 - 469", amountOrCoverage: "R8 500", requirement: "Applicant score 410 to 469."),
                BursaryAward(name: "Leadership Award", amountOrCoverage: "R4 200", requirement: "Manual proof for Head Prefects submitted by 31 March.")
            ],
            notes: "NSFAS-funded students are not allocated Scholar Merit Awards."
        ),
        UniversityBursary(
            universityName: "University of the Western Cape (UWC)",
            abbreviation: "UWC",
            applicationType: .manual,
            summary: "Merit awards require a manual application after receiving formal acceptance.",
            awards: [
                BursaryAward(name: "NSC 'A' Aggregate", amountOrCoverage: "100% Tuition", requirement: "Overall 'A' aggregate in NSC examinations."),
                BursaryAward(name: "NSC 'B' Aggregate", amountOrCoverage: "75% Tuition", requirement: "Overall 'B' aggregate in NSC examinations.")
            ],
            notes: "You must apply manually once accepted to UWC."
        )
    ]
    
    // Verified Dataset of 15 Private & Corporate Bursaries
    let privateBursaries: [PrivateBursaryItem] = [
        PrivateBursaryItem(
            name: "Funza Lushaka Bursary",
            isOpen: true,
            applicationDates: "Opens 1 Oct 2026; Closes 31 Jan 2027",
            compensation: "Covers tuition, accommodation, meals, books, learning materials, and a small living allowance (varies by institution).",
            eligibility: "South African citizens (30 or younger for first-time applicants). Must be accepted for an initial teacher-education BEd at a public university, specialising in at least two priority subjects. Service obligation applies.",
            applicationURL: URL(string: "https://www.funzalushaka.doe.gov.za/Home/")
        ),
        PrivateBursaryItem(
            name: "IDC External Bursary Scheme",
            isOpen: false,
            applicationDates: "1 June 2026 – 30 September 2026 (Closed)",
            compensation: "Tuition, university or off-campus accommodation, once-off laptop, meals, and transport.",
            eligibility: "Unemployed South African citizens aged 26 or younger, full-time first qualification at a public university or UoT in IDC-listed fields. Household income threshold up to R350,000 (R350k–R600k considered after assessment). 75% APS threshold for matrics, 65% recent university average.",
            applicationURL: URL(string: "https://www.idc.co.za/bursaries/")
        ),
        PrivateBursaryItem(
            name: "NDMC External Bursary",
            isOpen: false,
            applicationDates: "Closed 30 September 2026",
            compensation: "Undergraduate: 100% of tuition and registration fees (accommodation, meals, books, travel excluded). Master's research allowance capped at R11,000.",
            eligibility: "South African citizens applying/accepted/registered for a full undergraduate programme in Disaster Management or Fire Technology/Fire Engineering at a recognized South African public higher-education institution. At least 60% average in latest results.",
            applicationURL: URL(string: "https://onlinebursary.ndmc.gov.za/")
        ),
        PrivateBursaryItem(
            name: "SARAO Freestanding Undergraduate Scholarship",
            isOpen: false,
            applicationDates: "1 June 2026 – 14 August 2026 (Closed)",
            compensation: "R183,000 scholarship level plus a once-off R13,000 laptop grant.",
            eligibility: "South African citizens and permanent residents studying/planning to study listed engineering or science degrees. Engineering: 70% in Grade 12 Math or 65% undergraduate GPA. Science: 70% in Grade 12 Math and Physical Science, or 65% undergraduate GPA.",
            applicationURL: URL(string: "https://www.sarao.ac.za/researchandstudy/undergraduate-scholarships/")
        ),
        PrivateBursaryItem(
            name: "Garden Route District Municipality External Bursary",
            isOpen: true,
            applicationDates: "Opens 1 Sept 2026; Closes 31 Oct 2026",
            compensation: "Financial assistance towards full-time study (exact amount n/a).",
            eligibility: "Grade 12 learners, individuals who passed Grade 12, and current students for 2027 full-time study at a SAQA-accredited institution. Parents must permanently reside in the Garden Route municipal area.",
            applicationURL: URL(string: "https://www.gardenroute.gov.za/category/human-resources/")
        ),
        PrivateBursaryItem(
            name: "BASF South Africa Trust Bursary",
            isOpen: true,
            applicationDates: "Closes 22 January 2027",
            compensation: "Covers tuition, textbooks, accommodation, and a monthly stipend.",
            eligibility: "2026 matriculants entering first year in 2027 at a recognized tertiary institution for Chemistry, qualifying Sciences, or Engineering. Exceptional academic results and proof of university acceptance required.",
            applicationURL: URL(string: "https://studies.nwu.ac.za/af/node/22633")
        ),
        PrivateBursaryItem(
            name: "Sasol Bursary — Engineering & Science",
            isOpen: false,
            applicationDates: "1 April 2026 – 17 May 2026 (Closed)",
            compensation: "Covers tuition and a living allowance, including psychosocial support.",
            eligibility: "South African citizens by birth permanently residing in SA, full-time study in 2027 at a Sasol-approved public university in eligible disciplines. BEng/BScEng requires Mathematics Level 6, Physical Science Level 6.",
            applicationURL: URL(string: "https://sasol.com")
        ),
        PrivateBursaryItem(
            name: "Sasol Foundation Bursary Programme",
            isOpen: false,
            applicationDates: "1 August 2026 – 23 August 2026 (Closed)",
            compensation: "All-inclusive undergraduate bursary with additional student support.",
            eligibility: "Academically talented learners/students from Sasol’s local communities, children of Sasol employees, and Khanyisa shareholders. Funds STEM mainly, with limited non-STEM awards.",
            applicationURL: URL(string: "https://www.sasol.com")
        ),
        PrivateBursaryItem(
            name: "CSIR Bursary Programme",
            isOpen: false,
            applicationDates: "Closed 15 September 2026",
            compensation: "Registration, tuition, books, accommodation, living allowance, and a once-off laptop allowance. Work-back obligation applies.",
            eligibility: "South African citizens entering full-time undergraduate study in an eligible field at a public university. Grade 12 requirements include English Level 5, Mathematics Level 6, and Physical Science Level 6.",
            applicationURL: URL(string: "https://www.csir.co.za/careers/students-graduates/bursaries")
        ),
        PrivateBursaryItem(
            name: "CSIR–Sasol Foundation Bursary Programme",
            isOpen: false,
            applicationDates: "Closed 15 September 2026",
            compensation: "Registration, tuition, books, accommodation, living allowance, once-off laptop allowance, plus academic and career support. Work-back obligation applies.",
            eligibility: "South African citizens entering full-time undergraduate study in Engineering, Computer Science, IT, Data Science, or Genetics/Cell Biology at a public university. Grade 12: English Level 5, Math Level 6, Physical Science Level 6.",
            applicationURL: URL(string: "https://www.csir.co.za/careers/students-graduates/bursaries")
        ),
        PrivateBursaryItem(
            name: "DFFE Full-Time Bursary Programme",
            isOpen: false,
            applicationDates: "Closed 2 October 2026",
            compensation: "Maximum R80,000 per student per year.",
            eligibility: "Full-time students or unemployed Grade 12 learners studying/intending to study in a field listed in the 2027 DFFE call. Must participate in public-service internship after completing studies.",
            applicationURL: URL(string: "https://www.dffe.gov.za/bursaries")
        ),
        PrivateBursaryItem(
            name: "Masakh’iSizwe Bursary",
            isOpen: false,
            applicationDates: "1 April 2026 – 31 August 2026 (Closed)",
            compensation: "Covers tuition, prescribed books and materials, support programmes, accommodation, meals or transport costs.",
            eligibility: "Full-time applicants in Engineering and Built Environment fields (Civil Engineering, Geomatics, Architecture, Quantity Surveying) at CPUT, Stellenbosch University, or UCT. Prioritises disadvantaged applicants, women, students with disabilities, and rural learners.",
            applicationURL: URL(string: "https://wa-dtpw-misbursary-prod-zan.azurewebsites.net/")
        ),
        PrivateBursaryItem(
            name: "Ninety One Changeblazers Bursary",
            isOpen: false,
            applicationDates: "Closed 31 August 2026",
            compensation: "Tuition, accommodation, meals, learning materials, tutoring, career guidance, and wellbeing support.",
            eligibility: "South African citizens under 21 in 2027, full-time study in listed fields. Strong academic performance, leadership, financial need (household income below R600,000/yr), preferably 70%+ in Grade 11 English and Math/Sciences.",
            applicationURL: URL(string: "https://www.uwc.ac.za")
        ),
        PrivateBursaryItem(
            name: "Gallagher Foundation South Africa Scholarship",
            isOpen: false,
            applicationDates: "12 June 2026 – 31 July 2026 (Closed)",
            compensation: "Tuition, accommodation, meals, books/supplies, laptop, personal-expense allowance, and travel stipend.",
            eligibility: "South African citizens entering first-year undergraduate study in 2027 for a 4-year UCT degree or 6-year medical degree. Meets financial criteria for NSFAS / student loan. Evidence of academic achievement, leadership, and community commitment.",
            applicationURL: URL(string: "https://gallagherfoundation.tfaforms.net/49")
        ),
        PrivateBursaryItem(
            name: "City of Cape Town External Bursary",
            isOpen: false,
            applicationDates: "Closed 31 August 2026",
            compensation: "Financial support for registration, examination, and class fees.",
            eligibility: "Cape Town residents studying full-time at an accredited SA institution in a scarce skill field identified by the City. No other financial assistance. Grade 12 applicants require a 65% average.",
            applicationURL: URL(string: "https://capetown.gov.za")
        )
    ]
    
    var filteredPrivateBursaries: [PrivateBursaryItem] {
        privateBursaries.filter { bursary in
            let matchesSearch = searchText.isEmpty ||
                bursary.name.localizedStandardContains(searchText) ||
                bursary.compensation.localizedStandardContains(searchText) ||
                bursary.eligibility.localizedStandardContains(searchText)
            
            switch filterSelection {
            case .all:
                return matchesSearch
            case .open:
                return matchesSearch && bursary.isOpen
            case .closed:
                return matchesSearch && !bursary.isOpen
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // Custom Animated Segmented Control
                    CustomSegmentedControl(selectedTab: $selectedTab)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    // Main Content with Slide & Fade Animation
                    Group {
                        if selectedTab == 0 {
                            ScrollView {
                                VStack(spacing: 14) {
                                    ForEach(universityBursaries) { bursary in
                                        Button(action: {
                                            selectedBursary = bursary
                                        }) {
                                            HStack(alignment: .top) {
                                                VStack(alignment: .leading, spacing: 8) {
                                                    HStack {
                                                        Text(bursary.abbreviation)
                                                            .font(.caption)
                                                            .fontWeight(.bold)
                                                            .padding(.horizontal, 8)
                                                            .padding(.vertical, 4)
                                                            .background(Color.blue.opacity(0.2))
                                                            .foregroundStyle(.blue)
                                                            .cornerRadius(6)
                                                        
                                                        Spacer()
                                                        
                                                        Text(bursary.applicationType.rawValue)
                                                            .font(.caption2)
                                                            .fontWeight(.bold)
                                                            .padding(.horizontal, 8)
                                                            .padding(.vertical, 4)
                                                            .background(bursary.applicationType.color.opacity(0.2))
                                                            .foregroundStyle(bursary.applicationType.color)
                                                            .cornerRadius(6)
                                                    }
                                                    
                                                    Text(bursary.universityName)
                                                        .font(.headline)
                                                        .fontWeight(.bold)
                                                        .foregroundStyle(.white)
                                                        .multilineTextAlignment(.leading)
                                                    
                                                    Text(bursary.summary)
                                                        .font(.caption)
                                                        .foregroundStyle(.gray)
                                                        .lineLimit(2)
                                                        .multilineTextAlignment(.leading)
                                                }
                                                
                                                Image(systemName: "chevron.right")
                                                    .font(.caption)
                                                    .foregroundStyle(.gray)
                                                    .padding(.top, 4)
                                            }
                                            .padding()
                                            .background(.ultraThinMaterial)
                                            .cornerRadius(14)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 90)
                            }
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                        } else {
                            // Private Bursary Tab View
                            VStack(spacing: 12) {
                                // Search Bar
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundStyle(.gray)
                                    TextField("Search private bursaries...", text: $searchText)
                                        .foregroundStyle(.white)
                                    if !searchText.isEmpty {
                                        Button(action: { searchText = "" }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(.gray)
                                        }
                                    }
                                }
                                .padding(10)
                                .background(Color.white.opacity(0.08))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                
                                // Open / Closed Filter Options
                                Picker("Filter Status", selection: $filterSelection) {
                                    ForEach(PrivateFilterOption.allCases) { option in
                                        Text(option.rawValue).tag(option)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding(.horizontal)
                                
                                ScrollView {
                                    LazyVStack(spacing: 14) {
                                        if filteredPrivateBursaries.isEmpty {
                                            VStack(spacing: 10) {
                                                Image(systemName: "doc.text.magnifyingglass")
                                                    .font(.system(size: 40))
                                                    .foregroundStyle(.gray)
                                                Text("No matching private bursaries found.")
                                                    .foregroundStyle(.gray)
                                                    .font(.subheadline)
                                            }
                                            .padding(.top, 60)
                                        } else {
                                            ForEach(filteredPrivateBursaries) { bursary in
                                                PrivateBursaryCardView(bursary: bursary)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom, 90)
                                }
                            }
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .trailing).combined(with: .opacity)
                            ))
                        }
                    }
                }
            }
            .navigationTitle("Bursaries & Grants")
            .preferredColorScheme(.dark)
            .sheet(item: $selectedBursary) { bursary in
                BursaryDetailView(bursary: bursary)
            }
        }
    }
}

// MARK: - Custom Sliding Segmented Picker

struct CustomSegmentedControl: View {
    @Binding var selectedTab: Int
    @Namespace private var animationNamespace
    
    var body: some View {
        HStack(spacing: 0) {
            // University Tab Button
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    selectedTab = 0
                }
            }) {
                Text("University")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(selectedTab == 0 ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        ZStack {
                            if selectedTab == 0 {
                                Capsule()
                                    .fill(Color.white.opacity(0.2))
                                    .matchedGeometryEffect(id: "SEGMENT", in: animationNamespace)
                            }
                        }
                    )
            }
            
            // Private Tab Button
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    selectedTab = 1
                }
            }) {
                Text("Private")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(selectedTab == 1 ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        ZStack {
                            if selectedTab == 1 {
                                Capsule()
                                    .fill(Color.white.opacity(0.2))
                                    .matchedGeometryEffect(id: "SEGMENT", in: animationNamespace)
                            }
                        }
                    )
            }
        }
        .padding(4)
        .background(Color.white.opacity(0.1))
        .clipShape(Capsule())
    }
}

// MARK: - Private Bursary Card Component

struct PrivateBursaryCardView: View {
    let bursary: PrivateBursaryItem
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header: Title & Status Badge
            HStack(alignment: .top) {
                Text(bursary.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text(bursary.isOpen ? "OPEN" : "CLOSED")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(bursary.isOpen ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .foregroundStyle(bursary.isOpen ? Color.green : Color.red)
                    .cornerRadius(6)
            }
            
            // Dates
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.caption)
                    .foregroundStyle(.blue)
                Text(bursary.applicationDates)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            // Coverage Summary
            VStack(alignment: .leading, spacing: 4) {
                Text("What it covers:")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                Text(bursary.compensation)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.9))
            }
            
            // Expandable Eligibility
            if isExpanded {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Eligibility Requirements:")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                    Text(bursary.eligibility)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            // Footer Controls
            HStack {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isExpanded.toggle()
                    }
                }) {
                    Text(isExpanded ? "Show Less" : "View Eligibility")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                }
                
                Spacer()
                
                if let url = bursary.applicationURL {
                    Link(destination: url) {
                        HStack(spacing: 4) {
                            Text("Apply Now")
                            Image(systemName: "arrow.up.right.square")
                        }
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(bursary.isOpen ? Color.blue : Color.gray.opacity(0.3))
                        .foregroundStyle(bursary.isOpen ? Color.white : Color.gray)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Bursary Detail Sheet View

struct BursaryDetailView: View {
    let bursary: UniversityBursary
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(bursary.abbreviation)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .foregroundStyle(.blue)
                                .cornerRadius(8)
                            
                            Spacer()
                            
                            Text(bursary.applicationType.rawValue)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(bursary.applicationType.color.opacity(0.2))
                                .foregroundStyle(bursary.applicationType.color)
                                .cornerRadius(8)
                        }
                        
                        Text(bursary.universityName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    
                    Text(bursary.summary)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    Divider()
                        .background(.gray.opacity(0.5))
                    
                    // Available Scholarships & Bursaries Section
                    Text("Available Scholarships & Bursaries")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    VStack(spacing: 12) {
                        ForEach(bursary.awards) { award in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(award.name)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Text(award.amountOrCoverage)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.green)
                                }
                                Text(award.requirement)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(12)
                        }
                    }
                    
                    if !bursary.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Important Rules & Deadlines")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.orange)
                            Text(bursary.notes)
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Bursary Details")
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
}

#Preview {
    Bursary_Page()
}
