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
        
        ZStack {
            
            Color.dangerHighBg
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // HEADER
                VStack(spacing: 8) {
                    
                    Text("EMERGENCIA")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color.dangerHighText)
                    
                    Text("Ubicación actual")
                        .font(.subheadline)
                        .foregroundColor(Color.appTextSecondary)
                    
                    Text("\(location.latitude), \(location.longitude)")
                        .font(.footnote)
                        .foregroundColor(Color.appTextDark)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                // DESCRIPCIÓN
                Text(description)
                    .font(.body)
                    .foregroundColor(Color.appTextDark)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4)
                
                Spacer()
                
                // ACTIONS
                VStack(spacing: 12) {
                    
                    Button(action: {
                        callNumber("9514763358")
                    }) {
                        Text("Llamar 911")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.dangerHighText)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: Color.dangerHighText.opacity(0.3), radius: 6)
                    }
                    
                    Button(action: {
                        callNumber("9514763358")
                    }) {
                        Text("Control Animal")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.dangerModerateText)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: Color.dangerModerateText.opacity(0.3), radius: 6)
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cerrar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.appTextTertiary.opacity(0.2))
                            .foregroundColor(Color.appTextDark)
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
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
