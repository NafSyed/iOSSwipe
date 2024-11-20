//
//  SwipeVM.swift
//  Swipe
//
//  Created by Nafeez Ahmed on 12/11/24.
//

import SwiftUI
import CoreData
import Combine
import Network

class SwipeVM: ObservableObject {
    @Published var SwipeProducts: [SwipeModel] = []
    @Published var searchQuery: String = ""
    @Published var productType: String = ""
    @Published var productName: String = ""
    @Published var price: Double = 0.0
    @Published var taxRate: Double = 0.0
    @Published var selectedImageData: String? = nil
    @Published var isSubmitting = false
    @Published var successMessage = ""
    @Published var errorMessage = ""
    private var networkMonitor = NetworkMonitor()
    @Published var selectedImage: UIImage?
    @Published var favoriteProductNames: Set<String> = []

    private let favoritesKey = "favoriteProductNames"
    private let storedDataKey = "storedSwipeData"
    private var cancellables: Set<AnyCancellable> = []

    init() {
        loadFavorites()
        let storedData = loadStoredData()

        networkMonitor.$isConnected
            .sink { [weak self] isConnected in
                self?.handleNetworkChange(isConnected: isConnected)
            }
            .store(in: &cancellables)

        if networkMonitor.isConnected {
            storedData.forEach { data in
                sendSwipeDataToServer(data: data)
            }
        }
    }


    private func handleNetworkChange(isConnected: Bool) {
        if isConnected {
            attemptToSendStoredData()
        }
    }

    private func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.object(forKey: favoritesKey) as? [String] {
            favoriteProductNames = Set(savedFavorites)
        }
    }

    private func saveFavorites() {
        let favoritesArray = Array(favoriteProductNames)
        UserDefaults.standard.set(favoritesArray, forKey: favoritesKey)
    }

    func toggleFavorite(_ product: SwipeModel) {
        if favoriteProductNames.contains(product.product_name) {
            favoriteProductNames.remove(product.product_name)
        } else {
            favoriteProductNames.insert(product.product_name)
        }
        saveFavorites()
    }

    var filteredProducts: [SwipeModel] {
        let filtered = searchQuery.isEmpty ? SwipeProducts : SwipeProducts.filter {
            $0.product_name.localizedCaseInsensitiveContains(searchQuery)
        }

        return filtered.sorted {
            favoriteProductNames.contains($0.product_name) && !favoriteProductNames.contains($1.product_name)
        }
    }

    func getSwipeData() async throws -> [SwipeModel] {
        guard let url = URL(string: "https://app.getswipe.in/api/public/get") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([SwipeModel].self, from: data)
    }

    @MainActor
    func refreshData() async {
        self.SwipeProducts = []
        do {
            let refreshedData = try await getSwipeData()
            self.SwipeProducts = refreshedData
        } catch {
            print("Error refreshing data: \(error)")
        }
    }

    func postSwipeData() {
        guard !productName.isEmpty, !productType.isEmpty else {
            errorMessage = "Product name and type are required."
            isSubmitting = false
            return
        }
        let data = SwipeModel(
            image: "",
            price: price,
            product_name: productName,
            product_type: productType,
            tax: taxRate
        )
        if networkMonitor.isConnected {
            sendSwipeDataToServer(data: data)
        } else {
            storeSwipeDataLocally(data: data)
        }
    }

    private func sendSwipeDataToServer(data: SwipeModel) {
        guard let url = URL(string: "https://app.getswipe.in/api/public/add") else {
            errorMessage = "Invalid API URL."
            isSubmitting = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()

        // Add text fields to the request
        let fields: [String: Any] = [
            "product_name": data.product_name,
            "product_type": data.product_type,
            "price": data.price,
            "tax": data.tax
        ]
        for (key, value) in fields {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        // Add the image file to the request if available
        if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"image.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        } else if let imageData = selectedImage?.pngData() {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"image.png\"\r\n")
            body.append("Content-Type: image/png\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }

        // End the multipart form data
        body.append("--\(boundary)--\r\n")
        request.httpBody = body

        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isSubmitting = false
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                guard let data = data else {
                    self.errorMessage = "No data received from server."
                    return
                }
                print("Raw Response:", String(data: data, encoding: .utf8) ?? "Unable to print response")
                do {
                    let responseData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let message = responseData?["message"] as? String {
                        self.successMessage = message
                    }
                    if let productDetails = responseData?["product_details"] as? [String: Any] {
                        if let imageURL = productDetails["image"] as? String {
                            print("Uploaded Image URL: \(imageURL)")
                        }
                    }
                } catch {
                    self.errorMessage = "Failed to decode the server response."
                    print("Decoding Error: \(error)")
                }
            }
        }.resume()
    }

    private func storeSwipeDataLocally(data: SwipeModel) {
        var storedData = loadStoredData()
        storedData.append(data)
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(storedData) {
            UserDefaults.standard.set(encodedData, forKey: storedDataKey)
            self.successMessage = "Data saved locally. Will be sent when network is available."
        } else {
            self.errorMessage = "Failed to store data locally."
        }
        isSubmitting = false
    }

    private func loadStoredData() -> [SwipeModel] {
        guard let storedData = UserDefaults.standard.data(forKey: storedDataKey),
              let decodedData = try? JSONDecoder().decode([SwipeModel].self, from: storedData) else {
            return []
        }
        return decodedData
    }

    private func attemptToSendStoredData() {
        let storedData = loadStoredData()
        for data in storedData {
            sendSwipeDataToServer(data: data)
        }
        clearStoredData()
    }

    private func clearStoredData() {
        UserDefaults.standard.removeObject(forKey: storedDataKey)
    }
}




extension Data {
    var isJPEG: Bool {
        return self.prefix(2) == Data([0xFF, 0xD8])
    }

    var isPNG: Bool {
        return self.prefix(8) == Data([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])
    }

    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

