import SwiftUI
import MapKit
import UIKit

func callNumber(_ number: String) {
    if let url = URL(string: "tel://\(number)"),
       UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
}

struct SOSView: View {
    
    let location: CLLocationCoordinate2D
    @State private var description: String = "Analizando situación..."
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {

        VStack(spacing: 20) {
            
            Text("EMERGENCIA")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            
            Text("Ubicación:")
                .foregroundColor(.white.opacity(0.7))
            
            Text("\(location.latitude), \(location.longitude)")
                .foregroundColor(.white)
                .font(.headline)
            
            Text(description)
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
            
            Spacer()
            
            VStack(spacing: 12) {
                
                Button("Llamar 911") {
                    callNumber("9514763358")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                Button("Control Animal") {
                    callNumber("9514763358")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.green.opacity(0.9))
        .onAppear {
            generateDescription()
        }
    }
    

    func generateDescription() {
        description = "Se reporta posible presencia de fauna silvestre cerca del usuario. Se recomienda mantener distancia, evitar contacto y notificar a autoridades correspondientes."
    }
}

#Preview {
    SOSView(
        location: CLLocationCoordinate2D(latitude: 25.65, longitude: -100.29)
    )
}
