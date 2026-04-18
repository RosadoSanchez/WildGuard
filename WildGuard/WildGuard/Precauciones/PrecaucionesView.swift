import SwiftUI
import FoundationModels

struct PrecaucionesView: View {
    
    let animal: String
    
    @State private var precautions: [String] = []
    @State private var isLoading = false
    
    var body: some View {
        
        ZStack {
            
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                
                Text("⚠️ Precauciones para \(animal)")
                    .font(.title.bold())
                    .foregroundColor(Color.appTextPrimary)
                    .multilineTextAlignment(.center)
                
                if isLoading {
                    ProgressView("Generando precauciones...")
                        .tint(Color.dangerModerateText)
                        .foregroundColor(Color.appTextSecondary)
                } else {
                    ForEach(precautions, id: \.self) { item in
                        Text("• \(item)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.dangerCautionBg)
                            .foregroundColor(Color.appTextDark)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 4)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            Task {
                await generatePrecautions()
            }
        }
    }
    
    func generatePrecautions() async {
        isLoading = true
        
        do {
            let session = LanguageModelSession()
            
            let prompt = """
            Genera una lista de precauciones claras y prácticas para una persona que se encuentra con un \(animal).

            Reglas:
            - NO Markdown
            - NO asteriscos
            - 4 a 6 precauciones máximo
            - Una idea por línea
            - Lenguaje simple y directo
            """
            
            let response = try await session.respond(to: prompt)
            
            let cleaned = response.content
                .replacingOccurrences(of: "**", with: "")
            
            let parsed = cleaned
                .split(separator: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            
            await MainActor.run {
                self.precautions = parsed
                self.isLoading = false
            }
            
        } catch {
            await MainActor.run {
                self.precautions = ["Error generando precauciones."]
                self.isLoading = false
            }
        }
    }
}

