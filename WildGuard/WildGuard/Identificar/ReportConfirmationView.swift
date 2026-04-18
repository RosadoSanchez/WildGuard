//
//  ReportConfirmationView.swift
//  WildGuard
//
//  Created by AGRM  on 18/04/26.
//

import SwiftUI

struct ReportConfirmationView: View {
    let animal: Animal
    @Environment(\.dismiss) private var dismiss
    @State private var reported = false

    private var formattedDate: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        f.locale = Locale(identifier: "es_MX")
        return f.string(from: Date())
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.appBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        animalCard.padding(.horizontal, 20).padding(.top, 12)
                        notificationSection.padding(.horizontal, 20)
                        Spacer().frame(height: 100)
                    }
                }

                bottomButtons.padding(.horizontal, 20).padding(.bottom, 24)
            }
            .navigationTitle("Confirmar reporte")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left").font(.system(size: 14, weight: .semibold))
                            Text("Atrás")
                        }
                        .foregroundStyle(Color.appGreen)
                    }
                }
            }
            .sheet(isPresented: $reported) {
                ReportSuccessView(animal: animal, onDone: { reported = false; dismiss() })
            }
        }
    }

    // MARK: - Animal card

    private var animalCard: some View {
        VStack(spacing: 12) {
            Group {
                if UIImage(named: animal.imageURL) != nil {
                    Image(animal.imageURL).resizable().scaledToFill()
                } else {
                    RoundedRectangle(cornerRadius: 16).fill(Color.appGreenLight)
                        .overlay {
                            Image(systemName: "pawprint.fill")
                                .font(.system(size: 28)).foregroundStyle(.white.opacity(0.6))
                        }
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(animal.name)
                .font(.system(size: 22, weight: .bold)).foregroundStyle(Color.appTextPrimary)
            Text(animal.scientificName)
                .font(.system(size: 14)).italic().foregroundStyle(Color.appTextSecondary)

            Divider()

            HStack {
                infoRow(label: "Fecha", value: formattedDate)
                Spacer()
                infoRow(label: "Zona", value: "Tu ubicación actual")
            }
            .padding(.horizontal, 4)
        }
        .padding(20)
        .background(.white, in: RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }

    private func infoRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.system(size: 11)).foregroundStyle(Color.appTextTertiary)
            Text(value).font(.system(size: 13, weight: .medium)).foregroundStyle(Color.appTextDark)
        }
    }

    // MARK: - Notification section

    private var notificationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quién será notificado")
                .font(.system(size: 18, weight: .bold)).foregroundStyle(Color.appTextPrimary)

            VStack(spacing: 16) {
                radiusCircles.frame(height: 200)
                Divider()
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Text("Usuarios en").font(.system(size: 15)).foregroundStyle(Color.appTextMedium)
                        Text("1 km").font(.system(size: 15, weight: .bold)).foregroundStyle(Color.appTextPrimary)
                        Text("recibirán una alerta").font(.system(size: 15)).foregroundStyle(Color.appTextMedium)
                    }
                    Text("4 personas aprox.")
                        .font(.system(size: 15, weight: .bold)).foregroundStyle(Color.appGreen)
                }
            }
            .padding(20)
            .background(.white, in: RoundedRectangle(cornerRadius: 18))
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
        }
    }

    private var radiusCircles: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let outerR = min(geo.size.width, geo.size.height) * 0.44
            let innerR = outerR * 0.58

            ZStack {
                Circle().fill(Color.radiusCircleOuter)
                    .frame(width: outerR * 2, height: outerR * 2).position(center)
                Circle().stroke(Color.radiusCircleStroke.opacity(0.6), lineWidth: 1.5)
                    .frame(width: outerR * 2, height: outerR * 2).position(center)
                Text("1 km").font(.system(size: 11, weight: .medium)).foregroundStyle(Color.appTextTertiary)
                    .position(x: center.x + outerR - 18, y: center.y - outerR + 14)

                Circle().fill(Color.radiusCircleInner)
                    .frame(width: innerR * 2, height: innerR * 2).position(center)
                Circle().stroke(Color.radiusCircleStroke.opacity(0.8), lineWidth: 1.5)
                    .frame(width: innerR * 2, height: innerR * 2).position(center)
                Text("500m").font(.system(size: 11, weight: .medium)).foregroundStyle(Color.appTextTertiary)
                    .position(x: center.x + innerR - 20, y: center.y - innerR + 12)

                Circle().fill(Color.appGreen).frame(width: 20, height: 20).position(center)
                Circle().fill(.white.opacity(0.4)).frame(width: 8, height: 8).position(center)
            }
        }
    }

    // MARK: - Bottom buttons

    private var bottomButtons: some View {
        VStack(spacing: 12) {
            Button { reported = true } label: {
                Text("Confirmar y alertar comunidad")
                    .font(.system(size: 16, weight: .semibold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                    .background(Color.appGreen, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.appGreen.opacity(0.3), radius: 10, x: 0, y: 4)
            }
            Button { dismiss() } label: {
                Text("Cancelar").font(.system(size: 15)).foregroundStyle(Color.appTextSecondary)
            }
        }
        .padding(.top, 8)
        .background(
            LinearGradient(colors: [Color.appBackground.opacity(0), Color.appBackground],
                           startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        )
    }
}

// MARK: - Success screen

struct ReportSuccessView: View {
    let animal: Animal
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                Circle().fill(Color.appGreenMint).frame(width: 90, height: 90)
                Image(systemName: "checkmark")
                    .font(.system(size: 36, weight: .bold)).foregroundStyle(Color.appGreen)
            }
            VStack(spacing: 8) {
                Text("¡Avistamiento reportado!")
                    .font(.system(size: 22, weight: .bold)).foregroundStyle(Color.appTextPrimary)
                Text("Las personas cercanas han sido alertadas sobre el \(animal.name).")
                    .font(.system(size: 15)).foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.center).padding(.horizontal, 32)
            }
            Spacer()
            Button(action: onDone) {
                Text("Listo")
                    .font(.system(size: 16, weight: .semibold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                    .background(Color.appGreen, in: RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 24).padding(.bottom, 32)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

#Preview { ReportConfirmationView(animal: Animal.all[3]) }
