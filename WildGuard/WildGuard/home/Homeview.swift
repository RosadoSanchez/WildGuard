//
//  Wildguardhome.swift
//  WildGuard
//
//  Created by AGRM  on 18/04/26.
//

import SwiftUI

// MARK: - Mock data models

struct AnimalCapture: Identifiable {
    let id       = UUID()
    let nickname : String
    let icon     : String
}

struct NearbySighting: Identifiable {
    let id            = UUID()
    let nickname      : String
    let scientificName: String
    let dangerLabel   : String
    let dangerColor   : Color
    let location      : String
    let timeAgo       : String
}

// MARK: - HomeView

struct Homeview: View {

    let userName      = "Valeria"
    let sightingCount = 3

    let captures: [AnimalCapture] = [
        AnimalCapture(nickname: "Bruno",    icon: "pawprint.fill"),
        AnimalCapture(nickname: "Bandit",   icon: "dog.fill"),
        AnimalCapture(nickname: "Bambi",    icon: "hare.fill"),
        AnimalCapture(nickname: "Colmillo", icon: "exclamationmark.triangle.fill"),
        AnimalCapture(nickname: "Fantasma", icon: "eye.slash.fill"),
    ]

    let nearbySightings: [NearbySighting] = [
        NearbySighting(nickname: "\"Colmillo\"", scientificName: "Sus scrofa",
                       dangerLabel: "Alto", dangerColor: Color(hex: "E63946"),
                       location: "Col. del Valle", timeAgo: "20 min"),
        NearbySighting(nickname: "\"Bruno\"", scientificName: "Ursus americanus",
                       dangerLabel: "Mod.", dangerColor: Color(hex: "F4A261"),
                       location: "Pedregal", timeAgo: "35 min"),
        NearbySighting(nickname: "\"Bandit\"", scientificName: "Taxidea taxus",
                       dangerLabel: "Bajo", dangerColor: Color(hex: "2D6A4F"),
                       location: "Condesa", timeAgo: "1 hr"),
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    navbar
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 20)

                    misCapturas
                        .padding(.bottom, 20)

                    heroCard
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)

                    cercaDeTi
                        .padding(.bottom, 24)

                    queNecesitas
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                }
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    // MARK: - Navbar

    private var navbar: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(Color.appGreen, in: RoundedRectangle(cornerRadius: 8))
                Text("WildGuard")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.appTextPrimary)
            }
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(.white, in: RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)

            Spacer()

            NavigationLink(destination: ProfileView(profile: sampleProfile)) {
                Text("VG")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.appGreen, in: Circle())
            }
        }
    }

    // MARK: - Mis capturas

    private var misCapturas: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Mis capturas")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)
                Spacer()
                NavigationLink(destination: MyCollectionView()) {
                    Text("Ver todo")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.appGreen)
                }
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(captures) { capture in
                        VStack(spacing: 6) {
                            Image(systemName: capture.icon)
                                .font(.system(size: 26, weight: .medium))
                                .foregroundStyle(Color.appGreen)
                                .frame(width: 60, height: 60)
                                .background(.white, in: RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                            Text(capture.nickname)
                                .font(.system(size: 12))
                                .foregroundStyle(Color.appTextSecondary)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }
        }
    }

    // MARK: - Hero card

    private var heroCard: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color(hex: "1B4332"), Color(hex: "2D6A4F"), Color(hex: "52B788")],
                startPoint: .topTrailing, endPoint: .bottomLeading
            )
            .overlay {
                LinearGradient(
                    colors: [.black.opacity(0.3), .clear, .black.opacity(0.4)],
                    startPoint: .top, endPoint: .bottom
                )
            }

            VStack {
                HStack {
                    Spacer()
                    Label("Alerta activa", systemImage: "exclamationmark.triangle.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(Color(hex: "E63946"), in: Capsule())
                }
                .padding(16)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Hola, \(userName)")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.85))
                Text("\(sightingCount) avistamientos cerca de ti hoy")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                NavigationLink(destination: MapView()) {
                    HStack(spacing: 4) {
                        Text("Ver mapa completo")
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.85))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }
                .padding(.top, 4)
            }
            .padding(20)
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Cerca de ti (sin "Ver todo")

    private var cercaDeTi: some View {
        VStack(alignment: .leading, spacing: 12) {

            // ← Solo el título, sin botón
            Text("Cerca de ti")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.appTextPrimary)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(nearbySightings) { sighting in
                        NearbyCard(sighting: sighting)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }
        }
    }

    // MARK: - Que necesitas

    private var queNecesitas: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("¿Qué necesitas?")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.appTextPrimary)

            HStack(spacing: 12) {
                actionCard(icon: "checkmark.shield.fill", title: "Prevención",
                           subtitle: "y cuidados",        color: Color(hex: "F4A261"))
                actionCard(icon: "leaf.fill",             title: "Aprender",
                           subtitle: "de la wildlife",    color: Color.appGreen)
            }
            .frame(height: 130)

            Button(action: {
                callNumber("9514763358")
            }) {
                HStack(spacing: 16) {
                    
                    Text("911")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundStyle(.white.opacity(0.9))
                        .frame(width: 56, height: 56)
                        .background(.white.opacity(0.2), in: Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Emergencia")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text("Llama si hay peligro inmediato")
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    Spacer()
                    Image(systemName: "phone.fill")
                        .font(.system(size: 20)).foregroundStyle(.white.opacity(0.85))
                }
                .padding(16)
                .background(Color(hex: "E63946"), in: RoundedRectangle(cornerRadius: 18))
            }
        }
    }

    private func actionCard(icon: String, title: String, subtitle: String, color: Color) -> some View {
        ZStack(alignment: .bottomLeading) {
            color
            Circle()
                .fill(.white.opacity(0.1))
                .frame(width: 100, height: 100)
                .offset(x: 40, y: 30)
            VStack(alignment: .leading, spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(.white.opacity(0.9))
                    .frame(width: 44, height: 44)
                    .background(.white.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
                Spacer()
                Text(title).font(.system(size: 16, weight: .bold)).foregroundStyle(.white)
                Text(subtitle).font(.system(size: 13)).foregroundStyle(.white.opacity(0.85))
            }
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

// MARK: - Nearby Card

struct NearbyCard: View {
    let sighting: NearbySighting

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AnimalImage(scientificName: sighting.scientificName, height: 200)
                .frame(width: 200, height: 200)

            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .center, endPoint: .bottom
            )

            VStack(alignment: .leading) {
                Text(sighting.dangerLabel)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(sighting.dangerColor, in: RoundedRectangle(cornerRadius: 8))
                    .padding(12)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(sighting.nickname)
                    .font(.system(size: 15, weight: .bold)).foregroundStyle(.white)
                Text("\(sighting.location) · \(sighting.timeAgo)")
                    .font(.system(size: 12)).foregroundStyle(.white.opacity(0.85))
            }
            .padding(12)
        }
        .frame(width: 200, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}

#Preview { Homeview() }
