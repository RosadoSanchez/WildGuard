//
//  MainTabView.swift
//  WildGuard
//
//  Created by valeriarossan on 18/04/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            // Inicio
            Homeview()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Inicio")
                }
            
            // Identificar
            NavigationStack {
                Identifyanimalview()
            }
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
        }
        .accentColor(.green)
    }
}
