//
//  StatsView.swift
//  WildGuard
//
//  Created by Samantha Carmona Santos on 18/04/26.
//

import SwiftUI

struct StatsView: View {
    
    let profile: Profile
    
    var body: some View {
        HStack {
            StatItem(number: "\(profile.reportCount)", label: "reportes")
            Divider()
            StatItem(number: "\(profile.species)", label: "especies")
            Divider()
            StatItem(number: "\(profile.points)", label: "pts. comunidad")
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct StatItem: View {
    let number: String
    let label: String
    
    var body: some View {
        VStack {
            Text(number)
                .font(.title2)
                .bold()
                .foregroundColor(.green)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}
