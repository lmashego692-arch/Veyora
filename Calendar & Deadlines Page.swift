//
//  Calendar & Deadlines Page.swift
//  Veyora
//
//  Created by Lesego Mashego on 2026/10/16.
//

import SwiftUI

// Helper function declared globally so Xcode can find it anywhere in the file
func makeDate(year: Int = 2026, month: Int, day: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    return Calendar.current.date(from: components) ?? Date()
}

struct Calendar___Deadlines_Page: View {
    // All 26 SA Public Universities
    let universities: [University] = [
        University(name: "University of Pretoria (UP)", abbreviation: "UP", openDate: makeDate(month: 4, day: 1), closeDate: makeDate(month: 6, day: 30), earlyCloseDate: makeDate(month: 5, day: 31), earlyCloseProgram: "Veterinary Science", officialLink: "https://www.up.ac.za", description: "Placeholder information for UP. Adjust here later."),
        
        University(name: "Sefako Makgatho Health Sciences University (SMU)", abbreviation: "SMU", openDate: makeDate(month: 4, day: 1), closeDate: makeDate(month: 7, day: 31), earlyCloseDate: nil, earlyCloseProgram: nil, officialLink: "https://www.smu.ac.za", description: "Placeholder information for SMU. Adjust here later."),
        
        University(name: "Tshwane University of Technology (TUT)", abbreviation: "TUT", openDate: makeDate(month: 4, day: 1), closeDate: makeDate(month: 7, day: 31), earlyCloseDate: makeDate(month: 6, day: 15), earlyCloseProgram: "Selected specialisation qualifications; international applicants", officialLink: "https://www.tut.ac.za", description: "Placeholder information for TUT. Adjust here later."),
        
        University(name: "University of Cape Town (UCT)", abbreviation: "UCT", openDate: makeDate(month: 4, day: 1), closeDate: makeDate(month: 7, day: 31), earlyCloseDate: nil, earlyCloseProgram: nil, officialLink: "https://www.uct.ac.za", description: "Placeholder information for UCT. Adjust here later."),
        
        University(name: "Stellenbosch University (SU)", abbreviation: "SU", openDate: makeDate(month: 4, day: 1), closeDate: makeDate(month: 7, day: 31), earlyCloseDate: nil, earlyCloseProgram: nil, officialLink: "https://www.sun.ac.za", description: "Placeholder information for Stellenbosch. Adjust here later."),
        
        University(name: "North-West University (NWU)", abbreviation: "NWU", openDate: makeDate(month: 6, day: 1), closeDate: makeDate(month: 8, day: 31), earlyCloseDate: makeDate(month: 6, day: 30), earlyCloseProgram: "Selection courses, except Urban and Regional Planning", officialLink: "https://www.nwu.ac.za", description: "Placeholder information for NWU. Adjust here later."),
        
        University(name: "Durban University of Technology (DUT)", abbreviation: "DUT", openDate: makeDate(month: 3, day: 1), closeDate: makeDate(month: 9, day: 30), earlyCloseDate: nil, earlyCloseProgram: "Some health-science programmes; dates vary", officialLink: "https://www.dut.ac.za", description: "Placeholder information for DUT. Adjust here later."),
        
        University(name: "Mangosuthu University of Technology (MUT)", abbreviation: "MUT", openDate: makeDate(month: 3, day: 1), closeDate: makeDate(month: 9, day: 30), earlyCloseDate: nil, earlyCloseProgram: nil, officialLink: "https://www.mut.ac.za", description: "Placeholder information for MUT. Adjust here later."),
        
        University(name: "Nelson Mandela University (NMU)", abbreviation: "NMU", openDate: makeDate(month: 4, day: 1), closeDate: makeDate(month: 9, day: 30), earlyCloseDate: makeDate(month: 6, day: 30), earlyCloseProgram: "Medicine, Nursing, Pharmacy, Diagnostic Radiography", officialLink: "https://www.mandela.ac.za", description: "Placeholder information for NMU. Adjust here later."),
        
        University(name: "Rhodes University", abbreviation: "Rhodes", openDate: makeDate(month: 4, day: 1), closeDate: makeDate(month: 9, day: 30), earlyCloseDate: nil, earlyCloseProgram: nil, officialLink: "https://www.ru.ac.za", description: "Placeholder information for Rhodes. Adjust here later."),
        
        University(name: "Sol Plaatje University (SPU)", abbreviation: "SPU", openDate: makeDate(month: 4, day: 1), closeDate: makeDate(month: 9, day: 30), earlyCloseDate: nil, earlyCloseProgram: nil, officialLink: "https://www.spu.ac.za", description: "Placeholder information for SPU. Adjust here later."),
        
        University(name: "Central University of Technology (CUT)", abbreviation: "CUT", openDate: makeDate(month: 4, day: 1), closeDate: makeDate(month: 9, day: 30), earlyCloseDate: nil, earlyCloseProgram: nil, officialLink: "https://www.cut.ac.za", description: "Placeholder information for CUT. Adjust here later."),
        
        University(name: "University of the Western Cape (UWC)", abbreviation: "UWC", openDate: makeDate(month: 4, day: 1), closeDate: makeDate(month: 9, day: 30), earlyCloseDate: nil, earlyCloseProgram: nil, officialLink: "https://www.uwc.ac.za", description: "Placeholder information for UWC. Adjust here later."),
        
        University(name: "University of the Free State (UFS)", abbreviation: "UFS", openDate: makeDate(month: 4, day: 1), closeDate: makeDate(month: 9, day: 30), earlyCloseDate: makeDate(month: 5, day: 31), earlyCloseProgram: "Medicine, Occupational Therapy, Optometry, Physiotherapy, Radiation Sciences, Biokinetics, Dietetics, Sport Coaching", officialLink: "https://www.ufs.ac.za", description: "Placeholder information for UFS. Adjust here later."),
        
        University(name: "University of KwaZulu-Natal (UKZN)", abbreviation: "UKZN", openDate: makeDate(month: 3, day: 1), closeDate: makeDate(month: 9, day: 30), earlyCloseDate: makeDate(month: 6, day: 30), earlyCloseProgram: "Medicine (MBChB)", officialLink: "https://www.ukzn.ac.za", description: "Placeholder information for UKZN. Adjust here later."),
        
        University(name: "University of Limpopo (UL)", abbreviation: "UL", openDate: makeDate(month: 5, day: 1), closeDate: makeDate(month: 9, day: 30), earlyCloseDate: makeDate(month: 7, day: 30), earlyCloseProgram: "Medicine (MBChB); international applicants", officialLink: "https://www.ul.ac.za", description: "Placeholder information for UL. Adjust here later."),
        
        University(name: "University of Venda (UNIVEN)", abbreviation: "UNIVEN", openDate: makeDate(month: 5, day: 1), closeDate: makeDate(month: 9, day: 30), earlyCloseDate: nil, earlyCloseProgram: nil, officialLink: "https://www.univen.ac.za", description: "Placeholder information for UNIVEN. Adjust here later."),
        
        University(name: "University of Zululand (UNIZULU)", abbreviation: "UNIZULU", openDate: makeDate(month: 3, day: 1), closeDate: makeDate(month: 9, day: 30), earlyCloseDate: nil, earlyCloseProgram: nil, officialLink: "https://www.unizulu.ac.za", description: "Placeholder information for UNIZULU. Adjust here later."),
        
        University(name: "Cape Peninsula University of Technology (CPUT)", abbreviation: "CPUT", openDate: makeDate(month: 5, day: 11), closeDate: makeDate(month: 9, day: 30), earlyCloseDate: makeDate(month: 6, day: 30), earlyCloseProgram: "Dental Assisting, Nursing (Extended), Diagnostic Imaging", officialLink: "https://www.cput.ac.za", description: "Placeholder information for CPUT. Adjust here later."),
        
        University(name: "Vaal University of Technology (VUT)", abbreviation: "VUT", openDate: makeDate(month: 6, day: 1), closeDate: makeDate(month: 9, day: 30), earlyCloseDate: nil, earlyCloseProgram: nil, officialLink: "https://www.vut.ac.za", description: "Placeholder information for VUT. Adjust here later."),
        
        University(name: "University of the Witwatersrand (Wits)", abbreviation: "Wits", openDate: makeDate(month: 3, day: 1), closeDate: makeDate(month: 9, day: 30), earlyCloseDate: makeDate(month: 5, day: 31), earlyCloseProgram: "BA General (part-time, July intake)", officialLink: "https://www.wits.ac.za", description: "Placeholder information for Wits. Adjust here later."),
        
        University(name: "University of South Africa (UNISA)", abbreviation: "UNISA", openDate: makeDate(month: 8, day: 1), closeDate: makeDate(month: 10, day: 9), earlyCloseDate: nil, earlyCloseProgram: "Qualification-specific", officialLink: "https://www.unisa.ac.za", description: "Placeholder information for UNISA. Adjust here later."),
        
        University(name: "University of Johannesburg (UJ)", abbreviation: "UJ", openDate: makeDate(month: 4, day: 1), closeDate: makeDate(month: 10, day: 31), earlyCloseDate: nil, earlyCloseProgram: nil, officialLink: "https://www.uj.ac.za", description: "Placeholder information for UJ. Adjust here later."),
        
        University(name: "University of Fort Hare (UFH)", abbreviation: "UFH", openDate: makeDate(month: 6, day: 1), closeDate: makeDate(month: 10, day: 31), earlyCloseDate: nil, earlyCloseProgram: nil, officialLink: "https://www.ufh.ac.za", description: "Placeholder information for UFH. Adjust here later."),
        
        University(name: "Walter Sisulu University (WSU)", abbreviation: "WSU", openDate: makeDate(month: 6, day: 1), closeDate: makeDate(month: 10, day: 31), earlyCloseDate: nil, earlyCloseProgram: nil, officialLink: "https://www.wsu.ac.za", description: "Placeholder information for WSU. Adjust here later."),
        
        University(name: "University of Mpumalanga (UMP)", abbreviation: "UMP", openDate: makeDate(month: 6, day: 1), closeDate: makeDate(month: 11, day: 30), earlyCloseDate: nil, earlyCloseProgram: nil, officialLink: "https://www.ump.ac.za", description: "Placeholder information for UMP. Adjust here later.")
    ]
    
    // Sorts Open universities to the top (earliest closing first), and Closed universities at the bottom
    var sortedUniversities: [University] {
        universities.sorted { lhs, rhs in
            if lhs.isOpen == rhs.isOpen {
                return lhs.closeDate < rhs.closeDate
            }
            return lhs.isOpen && !rhs.isOpen
        }
    }
    
    @State private var selectedUniversity: University? = nil
    
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
                                    // Left side: Countdown if open
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
                                    
                                    // Right side: University Name (Bold) and Status below
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
                    .padding(.bottom, 80) // Prevents bottom floating toolbar overlap
                }
            }
            .navigationTitle("University Deadlines")
            .preferredColorScheme(.dark)
            .sheet(item: $selectedUniversity) { uni in
                UniversityDetailView(university: uni)
            }
        }
    }
}

#Preview {
    Calendar___Deadlines_Page()
}
