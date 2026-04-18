//
//  ProfileModel.swift
//  WildGuard
//
//  Created by Samantha Carmona Santos on 18/04/26.
//

import Foundation

struct Profile {
    let name: String
    let location: String
    let badge: String
    let badgeIcon: String
    
    let reports: Int
    let species: Int
    let points: Int
    
    let menuItems: [ProfileMenuItem]
    
    let sightings: [Sighting]
    var emergencyContacts: [EmergencyContact]
    let community: [CommunityMember]
}

struct ProfileMenuItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
}

struct EmergencyContact: Identifiable {
    let id = UUID()
    var name: String
    var phone: String
}

struct CommunityMember: Identifiable {
    let id = UUID()
    let name: String
    let isOnline: Bool
}

struct Sighting: Identifiable {
    let id = UUID()
    let title: String
    let date: String
}
