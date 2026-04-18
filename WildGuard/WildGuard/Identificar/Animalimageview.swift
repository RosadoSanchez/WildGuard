//
//  Animalimageview.swift
//  WildGuard
//
//  Created by AGRM  on 18/04/26.
//

import SwiftUI

// MARK: - iNaturalist Image Cache

@MainActor
class iNatImageCache: ObservableObject {
    static let shared = iNatImageCache()
    private var cache: [String: URL] = [:]

    func photoURL(for scientificName: String) async -> URL? {
        if let cached = cache[scientificName] { return cached }

        let query = scientificName
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.inaturalist.org/v1/taxa?q=\(query)&per_page=1&rank=species"

        guard let apiURL = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: apiURL)
            let json      = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let results   = json?["results"] as? [[String: Any]]
            let photo     = results?.first?["default_photo"] as? [String: Any]
            let photoStr  = photo?["medium_url"] as? String

            if let photoStr, let url = URL(string: photoStr) {
                cache[scientificName] = url
                return url
            }
        } catch { }
        return nil
    }
}

// MARK: - AnimalImageView

struct AnimalImage: View {
    let scientificName : String
    let height         : CGFloat

    @State private var imageURL   : URL?    = nil
    @State private var isLoading  : Bool    = true

    var body: some View {
        Group {
            if let imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        placeholder
                    case .empty:
                        shimmer
                    @unknown default:
                        placeholder
                    }
                }
            } else if isLoading {
                shimmer
            } else {
                placeholder
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .clipped()
        .task {
            imageURL  = await iNatImageCache.shared.photoURL(for: scientificName)
            isLoading = false
        }
    }

    private var shimmer: some View {
        Color.appShimmer
            .overlay {
                ProgressView().tint(Color.appGreenLight)
            }
    }

    private var placeholder: some View {
        LinearGradient(
            colors: [Color.appGreenPale, Color.appGreenLight],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        .overlay {
            Image(systemName: "pawprint.fill")
                .font(.system(size: 28))
                .foregroundStyle(.white.opacity(0.6))
        }
    }
}
