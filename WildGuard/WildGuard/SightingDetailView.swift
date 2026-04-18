import SwiftUI

struct SightingDetailView: View {
    let sighting: Sighting

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

            // 🔘 BOTÓN FIJO ABAJO
            Button("Ver precauciones") {
                // acción
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding()
            .background(.ultraThinMaterial) 
        }
    }
}

#Preview {
    SightingDetailView(
        sighting: sightings[0]
    )
}
