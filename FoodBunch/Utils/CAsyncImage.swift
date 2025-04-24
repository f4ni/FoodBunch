//
//  CAsyncImage.swift
//  FoodBunch
//
//  Created by Furkan ic on 23.04.2025.
//


import SwiftUI

struct CAsyncImage: View {
    
    private let url: URL?
    @State var image: Image? = nil
    @State  var isLoading = false

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        if let image = image {
            image
                .resizable()
                .scaledToFit()
        } else {
            ProgressView()
                .onAppear {
                    Task {
                        await loadImage()
                    }
                }
        }
    }

    private func loadImage() async {
        guard let url = url, !isLoading else { return }

        self.isLoading = true

        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let cachedImage = UIImage(data: cachedResponse.data) {
            await MainActor.run {
                self.image = Image(uiImage: cachedImage)
                self.isLoading = false
            }
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            let cachedData = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: request)

            if let uiImage = UIImage(data: data) {
                await MainActor.run {
                    self.image = Image(uiImage: uiImage)
                    self.isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}
