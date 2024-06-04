//
//  OpenFoodFactsAPIService.swift
//  GymApp
//
//  Created by Азат Зиганшин on 31.05.2024.
//

import Foundation
import Alamofire

actor TastyAPIService: FoodSearchService {
    private let apiKey = "5a394115abmsh2306f87fe9cee68p1b473djsn173cd2a1ec8d"
    private let searchUrl = "https://tasty.p.rapidapi.com/recipes/list"

    func fetchProducts(query: String) async throws -> [Product] {
        let headers: HTTPHeaders = [
            "x-rapidapi-host": "tasty.p.rapidapi.com",
            "x-rapidapi-key": apiKey
        ]

        let parameters: Parameters = [
            "q": query
        ]

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(searchUrl, parameters: parameters, headers: headers).responseDecodable(of: TastyResponse.self) { response in
                switch response.result {
                case .success(let tastyResponse):
                    let products = tastyResponse.results.compactMap { result -> Product? in
                        guard let name = result.name,
                              let imageUrl = result.thumbnailURL,
                              let nutrition = result.nutrition else {
                            return nil
                        }
                        let calories = nutrition.calories ?? 0
                        let protein = nutrition.protein ?? 0
                        let fat = nutrition.fat ?? 0
                        let carbohydrates = nutrition.carbohydrates ?? 0
                        return Product(name: name, imageUrl: imageUrl, calories: calories, protein: protein, fat: fat, carbohydrates: carbohydrates)
                    }
                    continuation.resume(returning: products)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
