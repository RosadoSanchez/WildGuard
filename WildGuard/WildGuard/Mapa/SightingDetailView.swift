import SwiftUI

struct SightingDetailView: View {
    
    let sighting: Sighting
    
    @State private var showPrecautions = false
    
    var body: some View {
        VStack(spacing: 0) {

            // CONTENIDO SCROLLEABLE
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    Image(sighting.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .clipped()
                        .cornerRadius(16)

                    Text(sighting.animal)
                        .font(.title)
                        .bold()

                    Text("\(sighting.timeAgo) · \(sighting.distance)")
                        .foregroundColor(.gray)

                    Text(sighting.description)
                        .font(.body)
                }
                .padding()
            }

            Button("Ver precauciones") {
                showPrecautions = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding()
            .background(.ultraThinMaterial)
        }
        .sheet(isPresented: $showPrecautions) {
            PrecaucionesView(animal: sighting.animal)
        }
    }
}

#Preview {
    SightingDetailView(
        sighting: sightings[0]
    )
}
