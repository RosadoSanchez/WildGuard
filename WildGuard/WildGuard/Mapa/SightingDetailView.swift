import SwiftUI

struct SightingDetailView: View {
    
    let sighting: Sighting
    
    @State private var showPrecautions = false
    
    var body: some View {
        VStack(spacing: 0) {

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    Image(sighting.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .clipped()
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.15), radius: 8)

                    Text(sighting.animal)
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.appTextPrimary)

                    Text("\(sighting.timeAgo) · \(sighting.distance)")
                        .font(.subheadline)
                        .foregroundColor(Color.appTextSecondary)

                    Text(sighting.description)
                        .font(.body)
                        .foregroundColor(Color.appTextDark)
                        .padding(.top, 4)
                }
                .padding()
            }

            Button(action: {
                showPrecautions = true
            }) {
                Text("Ver precauciones")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appGreen)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.appGreen.opacity(0.3), radius: 6, x: 0, y: 3)
            }
            .padding()
            .background(Color.appBackground)
        }
        .background(Color.appBackground.ignoresSafeArea())
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
