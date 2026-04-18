//
//  ProfileView.swift
//  WildGuard
//
//  Created by Samantha Carmona Santos on 18/04/26.
//

import SwiftUI

struct ProfileView: View {
    
    let profile: Profile
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Title
                    Text("Perfil")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                    
                    // Profile Card
                    ProfileCard(profile: profile)
                    
                    // Stats
                    StatsView(profile: profile)
                    
                    // Menu
                    VStack(spacing: 12) {
                        
                        // NOTIFICACIONES
                        NavigationLink {
                            SightingsView(sightings: profile.sightings)
                        } label: {
                            ProfileRow(
                                icon: "bell",
                                title: "Notificaciones",
                                subtitle: "Alertas de avistamientos"
                            )
                        }
                        
                        // ZONAS DE ALERTA
                        // TODO: Enable when AlertZonesView is ready
                        /*
                        NavigationLink {
                            MapView()
                        } label: {
                            ProfileRow(
                                icon: "map",
                                title: "Zonas de alerta",
                                subtitle: "Radio personalizado: 1km"
                            )
                        }
                        */

                        // Temporary placeholder
                        ProfileRow(
                            icon: "map",
                            title: "Zonas de alerta",
                            subtitle: "Radio personalizado: 1km"
                        )
                        .opacity(0.6)
                        
                        // PROTECCIÓN CIVIL
                        NavigationLink {
                            EmergencyView(contacts: profile.emergencyContacts)
                        } label: {
                            ProfileRow(
                                icon: "shield",
                                title: "Protección Civil",
                                subtitle: "Contactos de emergencia"
                            )
                        }
                        
                        // MI COMUNIDAD
                        NavigationLink {
                            CommunityView(members: profile.community)
                        } label: {
                            ProfileRow(
                                icon: "person.2",
                                title: "Mi comunidad",
                                subtitle: "Vecinos conectados: \(profile.community.count)"
                            )
                        }
                        
                        // ACCESIBILIDAD
                        NavigationLink {
                            AccessibilityView()
                        } label: {
                            ProfileRow(
                                icon: "eye",
                                title: "Accesibilidad",
                                subtitle: "Opciones de visibilidad"
                            )
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    ProfileView(profile: sampleProfile)
}

#Preview {
    ProfileView(profile: sampleProfile)
}

let sampleProfile = Profile(
    name: "María García",
    location: "Colonia del Valle, CDMX",
    badge: "Guardián del bosque",
    badgeIcon: "leaf.fill",
    reports: 8,
    species: 4,
    points: 142,
    menuItems: [
        ProfileMenuItem(icon: "bell", title: "Notificaciones", subtitle: "Alertas de avistamientos"),
        ProfileMenuItem(icon: "map", title: "Zonas de alerta", subtitle: "Radio personalizado: 1km"),
        ProfileMenuItem(icon: "shield", title: "Protección Civil", subtitle: "Contactos de emergencia"),
        ProfileMenuItem(icon: "person.2", title: "Mi comunidad", subtitle: "Vecinos conectados: 24")
    ],
    sightings: [
        Sighting(title: "Serpiente vista", date: "Hoy"),
        Sighting(title: "Araña peligrosa", date: "Ayer")
    ],

    emergencyContacts: [
        EmergencyContact(name: "Policía", phone: "911"),
        EmergencyContact(name: "Protección Civil", phone: "555-1234")
    ],

    community: [
        CommunityMember(name: "Juan", isOnline: true),
        CommunityMember(name: "Ana", isOnline: false),
        CommunityMember(name: "Luis", isOnline: true)
    ]
)
