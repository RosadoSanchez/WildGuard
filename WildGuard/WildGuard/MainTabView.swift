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
            IdentifyAnimalView()
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
        } .accentColor(Color.appGreen)
    }
}
