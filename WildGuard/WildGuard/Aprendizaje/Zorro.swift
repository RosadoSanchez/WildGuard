import SwiftUI
import FoundationModels

struct ZorroLearningView: View {
    
    let animalName = "Zorro"
    
    @State private var facts: [String] = []
    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            
            VStack(spacing: 16) {
                
                Image(animalName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(radius: 8)
                
                Text(animalName)
                    .font(.largeTitle.bold())
                
                // LOADING / FACTS
                if isLoading {
                    ProgressView("Generando con AI...")
                } else {
                    ForEach(facts, id: \.self) { fact in
                        Text("• \(fact)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                
                // BOTÓN
                Button("Generar con AI") {
                    Task { await generateFacts() }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding()
            .font(.system(size: 16, weight: .regular, design: .rounded))
        }
    }
    
    // MARK: - FOUNDATION MODELS CALL
    func generateFacts() async {
        isLoading = true
        
        do {
            let session = LanguageModelSession()
            
            let prompt = """
            Genera un parráfo introductorio corto sobre los osos negros americanos. Habla sobre su habitat, su dieta y sus características.
            También dame estos datos: Nivel de peligro del animal: 🟢 Bajo riesgo, 🟡 Precaución, 🔴 Alto riesgo
            Genera 4 datos educativos claros sobre el animal \(animalName).

            Reglas estrictas para los datos educativos:
            - NO uses Markdown
            - NO uses asteriscos (*)
            - NO uses negritas ni símbolos de formato
            - Devuelve solo texto plano
            - Un dato por línea
            - Una oración únicamente por dato.
            - Una viñeta por dato
            """
            
            let response = try await session.respond(to: prompt)
            
            let cleaned = response.content
                .replacingOccurrences(of: "**", with: "")
            
            let parsed = cleaned
                .split(separator: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            
            await MainActor.run {
                self.facts = parsed
                self.isLoading = false
            }
            
        } catch {
            await MainActor.run {
                self.facts = ["Error generando información con AI."]
                self.isLoading = false
            }
        }
    }
}
#Preview {
    VStack {
        ZorroLearningView()
    }
}
