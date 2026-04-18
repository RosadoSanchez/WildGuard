//
//  CommunityView.swift
//  WildGuard
//
//  Created by Samantha Carmona Santos on 18/04/26.
//

import SwiftUI

struct CommunityView: View {
    
    let members: [CommunityMember]
    
    var body: some View {
        List(members) { member in
            HStack {
                Circle()
                    .fill(member.isOnline ? Color.green : Color.gray)
                    .frame(width: 10, height: 10)
                
                Text(member.name)
                
                Spacer()
                
                Text(member.isOnline ? "Online" : "Offline")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Mi comunidad")
    }
}
