//
//  MainTabView.swift
//  WildGuard
//
//  Created by valeriarossan on 18/04/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Text("Inicio")
    }
}

struct IdentifyView: View {
    var body: some View {
        Text("Identificar")
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            
            // Inicio
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Inicio")
                }
            
            // Identificar
            IdentifyView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Identificar")
                }
            
            // Mapa
            MapView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Mapa")
                }
            
            // Perfil
            ProfileView(profile: sampleProfile)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Perfil")
                }
        } .accentColor(.green)
    }
}
