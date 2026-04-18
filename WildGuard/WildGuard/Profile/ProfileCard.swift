//
//  ProfileCard.swift
//  WildGuard
//
//  Created by Samantha Carmona Santos on 18/04/26.
//

import SwiftUI

struct ProfileCard: View {
    
    let profile: Profile
    
    var body: some View {
        HStack(spacing: 16) {
            
            Circle()
                .fill(Color.green)
                .frame(width: 60, height: 60)
                .overlay(
                    Text(String(profile.name.prefix(1)))
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(profile.name)
                    .font(.headline)
                
                Text(profile.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 4) {
                    Image(systemName: profile.badgeIcon)
                    Text(profile.badge)
                }
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.2))
                .foregroundColor(.green)
                .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}
