import SwiftUI
import MapKit
import UIKit

// MARK: - Model
struct Sighting: Identifiable, Equatable {
    let id = UUID()
    let animal: String
    let imageName: String
    let coordinate: CLLocationCoordinate2D
    let description: String
    let timeAgo: String
    let distance: String
    
    static func == (lhs: Sighting, rhs: Sighting) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Data
let sightings = [
    Sighting(
        animal: "Mapache",
        imageName: "Mapache",
        coordinate: CLLocationCoordinate2D(latitude: 25.65, longitude: -100.29),
        description: "Busca comida. No lo alimentes.",
        timeAgo: "Hace 3h",
        distance: "2.3 km"
    ),
    Sighting(
        animal: "Coyote",
        imageName: "Coyote",
        coordinate: CLLocationCoordinate2D(latitude: 25.66, longitude: -100.31),
        description: "Evita contacto visual prolongado.",
        timeAgo: "Hace 1h",
        distance: "1.1 km"
    ),
    Sighting(
        animal: "Jabalí",
        imageName: "Jabali",
        coordinate: CLLocationCoordinate2D(latitude: 25.65, longitude: -100.28),
        description: "Puede ser agresivo si se siente amenazado.",
        timeAgo: "Hace 20 min",
        distance: "800 m"
    ),
    Sighting(
        animal: "Zorro",
        imageName: "Zorro",
        coordinate: CLLocationCoordinate2D(latitude: 25.67, longitude: -100.31),
        description: "Generalmente tímido, no te acerques.",
        timeAgo: "Hace 2h",
        distance: "1.9 km"
    ),
    Sighting(
        animal: "Oso",
        imageName: "Oso",
        coordinate: CLLocationCoordinate2D(latitude: 25.64, longitude: -100.27),
        description: "Puede ser peligroso. Mantén distancia.",
        timeAgo: "Hace 5h",
        distance: "3.8 km"
    )
]

// MARK: - View
struct MapView: View {
    
    @State private var selectedSighting: Sighting?
    @State private var showSOSAlert = false
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.65, longitude: -100.29),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        NavigationStack{
            ZStack {
                
                // MAPA (FONDO)
                Map(
                    coordinateRegion: $region,
                    annotationItems: sightings
                ) { sighting in
                    MapAnnotation(coordinate: sighting.coordinate) {
                        Button {
                            selectedSighting = sighting
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 44, height: 44)
                                    .shadow(radius: 4)
                                
                                Image(systemName: "pawprint.fill")
                                    .foregroundColor(.pink)
                            }
                        }
                    }
                }
                .ignoresSafeArea()
                
                // HEADER
                VStack {
                    HStack {
                        Text("WildGuard")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Image(systemName: "pawprint")
                            .font(.title3)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                
                // BOTTOM CARD
                if selectedSighting == nil {
                    VStack {
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(sightings.count) avistamientos activos")
                                .font(.headline)
                            
                            Text("Toca un pin para ver detalles")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .padding()
                        .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: selectedSighting != nil)
                }
                
                // BOTÓN SOS (ENCIMA DE TODO)
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink {
                            SOSView(location: region.center)
                        } label: {
                            Text("SOS")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.red)
                                .clipShape(Circle())
                                .shadow(color: .red.opacity(0.4), radius: 10)
                        }
                        .padding()
                    }
                }        }
            // MODAL DE DETALLE
            .sheet(item: $selectedSighting) { sighting in
                SightingDetailView(sighting: sighting)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }}

// MARK: - Preview
#Preview {
    MapView()
}
