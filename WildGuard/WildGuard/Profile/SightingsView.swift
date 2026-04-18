
//
//  SightingsView.swift
//  WildGuard
//
//  Created by Samantha Carmona Santos on 18/04/26.
//

import SwiftUI

struct SightingsView: View {
    let reports: [Report]
    
    var body: some View {
        List(reports) { report in
            VStack(alignment: .leading) {
                Text(report.title)
                Text(report.date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Avistamientos")
    }
}


